//
//  FollowerFetcher.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/3/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import Firebase


struct Follower {
    var seen : Bool
    var userProfile : UserProfile
}

protocol FollowerFetcherDelegate : class {
    func newFollowerAdded(follower : Follower)
}


class FollowerFetcher {
    
    var db = Firestore.firestore()
    var listener : ListenerRegistration?
    
    var userProfileFetcherArray : [UserProfileFetcher] = []
    var userProfileSeenDict : [String : Bool] = [:] //userID : seen(or not)
    // Simple way to record if seen or not until userProfileReturnsFetch
    
    weak var delegate : FollowerFetcherDelegate?
    
    var unSeenFollowersOnly : Bool
    init(unSeenFollowersOnly : Bool) {
        self.unSeenFollowersOnly = unSeenFollowersOnly
    }
    
    
    func startMonitor() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        listener = db.collection("User-Profile").document(myUID).collection("Followers").addSnapshotListener({ (snap, err) in
            guard let docChange = snap?.documentChanges else { return }
            
            
            docChange.forEach({ (diff) in
                
                if diff.type == .added {
                    let userID = diff.document.documentID
                    if let seen = diff.document.data()["seen"] as? Bool , seen == true {
                        
                        if self.unSeenFollowersOnly == false {
                            self.userProfileSeenDict[userID] = true
                            self.getUserProfile(userID: userID)
                        }
                        
                    } else {
                        
                        self.userProfileSeenDict[userID] = false
                        self.getUserProfile(userID: userID)
                        
                    }
                    
                }
                
            })
            
        })
        
    }
    
    func removeListener() {
        if let listenr = listener {
            listenr.remove()
        }
    }
    
    func shutDown() {
        self.removeListener()
        self.delegate = nil
    }
    
    
    
    func getUserProfile(userID : String) {
        
        let uProfileFetcher = UserProfileFetcher(userID: userID)
        uProfileFetcher.getUserProfile()
        
        uProfileFetcher.delegate = self
        
    }
    
    
    
    
    
    public func postSeenForFollower(followerUserID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("User-Profile").document(myUID).collection("Followers").document(followerUserID)
         ref.getDocument { (snap, err) in
            guard let doc = snap else { return }
            guard doc.exists else { return }
            
            let data = ["seen":true] as [String:Any]
            ref.setData(data, merge: true)
            
        }
    
        
    }
    
}





extension FollowerFetcher : UserProfileFetcherDelegate {
    
    
    func userProfileUpdated(userID: String, userProfile: UserProfile) {
        
        let hasSeen = self.userProfileSeenDict[userID] ?? true
        let follower = Follower(seen: hasSeen, userProfile: userProfile)
        
        self.delegate?.newFollowerAdded(follower: follower)
        
        //clean up
        self.userProfileSeenDict[userID] = nil
        
        
    }
    
    
}
