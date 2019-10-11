//
//  FollowersTVC+Fetcher.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/29/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

extension FollowersTVC {
    
    
    func monitorUsersList() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.listener = db.collection("User-Profile").document(myUID).collection("Followers").addSnapshotListener({ (snap, err) in
            guard let docChanges = snap?.documentChanges else { return }
            
            for diff in docChanges {
                
                let userID = diff.document.documentID
                
                if diff.type == .added {
                    
                    let uProfileFetcher = UserProfileFetcher(userID: userID)
                    self.userProfileFetcherArray.append(uProfileFetcher)
                    uProfileFetcher.delegate = self
                    uProfileFetcher.getUserProfile()
                    
                }
                
                if diff.type == .removed {
                    
                    self.userProfileArray.removeAll(where: { $0.userID == userID })
                    
                }
                
                
            }
            
        })
    }
    
}



extension FollowersTVC : UserProfileFetcherDelegate {
    
    func userProfileUpdated(userID: String, userProfile: UserProfile) {
        
        self.userProfileArray.append(userProfile)
        
        self.sortUserProfileArray()
        
        self.tableView.reloadData()
    }
    
    func sortUserProfileArray() {
        self.userProfileArray.sort { $0.userName.lowercased() <= $1.userName.lowercased() }
    }
    
    
}
