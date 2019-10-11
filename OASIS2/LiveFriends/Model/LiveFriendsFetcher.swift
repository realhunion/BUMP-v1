//
//  LiveFriendsFetcher.swift
//  OASIS2
//
//  Created by Honey on 5/23/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

protocol LiveFriendsFetcherDelegate: class {
    func liveFriendUpdated(liveUser : LiveUser)
    func liveFriendRemoved(userID : String)
}

class LiveFriendsFetcher {
    
    var db = Firestore.firestore()
    
    weak var delegate: LiveFriendsFetcherDelegate?
    
    var followingListener : ListenerRegistration?
    
    var liveUserFetcherDict : [String : LiveUserFetcher] = [:] // [ userID : LiveUserFetcher ]
    
    
    
    init() {
        self.startMonitor()
    }
    
    
    func startMonitor() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        
        Constant.logTimestamp(label: "followMonitorStart")
        
        followingListener = db.collection("User-Profile").document(myUID).collection("Following").addSnapshotListener { (snap, err) in
            guard let diffs = snap?.documentChanges else { return }
            
            self.addLiveUserFetcher(userID: myUID)
           Constant.logTimestamp(label: "followingDataGotten")
            
            for diff in diffs {
                if (diff.type == .added) {
                    let userID = diff.document.documentID
                    self.addLiveUserFetcher(userID: userID)
                }
                if (diff.type == .removed) {
                    let userID = diff.document.documentID
                    self.removeLiveUserFetcher(userID: userID)
                }
            }
        }
        
    }
    
    private func removeListener() {
        if let listenr = followingListener {
            listenr.remove()
        }
    }
    
    public func shutDown() {
        self.liveUserFetcherDict.forEach { (key, value) in
            value.shutDown()
        }
        self.liveUserFetcherDict.removeAll()
        
        self.removeListener()
        self.delegate = nil
    }
    
    
    
    
    
    
    
    
    
    private func addLiveUserFetcher(userID : String) {
        guard liveUserFetcherDict[userID] == nil else { return }
        
        let liveUserFetcher = LiveUserFetcher(userID: userID, inCircleWithMonitorEnabled: false)
        liveUserFetcher.delegate = self
        liveUserFetcher.startMonitor()
        
        liveUserFetcherDict[userID] = liveUserFetcher
    }
    
    private func  removeLiveUserFetcher(userID : String) {
        
        liveUserFetcherDict[userID]?.shutDown()
        liveUserFetcherDict[userID] = nil
        
        self.delegate?.liveFriendRemoved(userID: userID)
    }
    
    
    
    
    
    
    
    
    public func enableInCircleWith(for userIDArray : [String]) {

        for (userID, liveUserFetcher) in liveUserFetcherDict {

            if userIDArray.contains(userID) {
                liveUserFetcher.resumeInCircleWithMonitor()
            }

        }
    }
    
    public func disableInCircleWith(for userIDArray : [String]) {
        
        for (userID, liveUserFetcher) in liveUserFetcherDict {
            
            if userIDArray.contains(userID) {
                liveUserFetcher.pauseInCircleWithMonitor()
            }
            
        }
    }
    
    
    
}


extension LiveFriendsFetcher : LiveUserFetcherDelegate {
    
    func liveUserUpdated(userID: String, liveUser: LiveUser) {
        
        Constant.logTimestamp(label: "_")
        Constant.logTimestamp(label: liveUser.userName)
        Constant.logTimestamp(label: liveUser.inCircleID)
        Constant.logTimestamp(label: liveUser.generateInCircleWithString() ?? "nil")
        
        if liveUser.userActive == true {
            self.delegate?.liveFriendUpdated(liveUser: liveUser)
        }
        else {
            self.delegate?.liveFriendRemoved(userID: liveUser.userID)
        }
    }
    
    
    
}
