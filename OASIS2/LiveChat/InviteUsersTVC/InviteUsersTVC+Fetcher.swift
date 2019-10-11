//
//  InviteUsersTableVC+Fetcher.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/22/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

struct InvitableUser {
    var userID : String
    var userName : String
    var userHandle : String
    var inviteSent : Bool
}

extension InviteUsersTVC {
    
    func getInvitableUsers() {
        
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        var followingUserIDs : [String] = []
        var followersUserIDs : [String] = []
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        db.collection("User-Profile").document(myUID).collection("Following").getDocuments { (snap, err) in
            
            guard let docs = snap?.documents else { dispatchGroup.leave(); return }
            
            for doc in docs {
                followingUserIDs.append(doc.documentID)
            }
            
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        db.collection("User-Profile").document(myUID).collection("Followers").getDocuments { (snap, err) in
            guard let docs = snap?.documents else { dispatchGroup.leave(); return }

            for doc in docs {
                followersUserIDs.append(doc.documentID)
            }

            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            
            let invitableUserIDs : [String] = followingUserIDs.filter( followersUserIDs.contains )
            
            var invitableUsers : [InvitableUser] = []
            
            for userID in invitableUserIDs {
                
                let uProfile = UserProfileFetcher(userID: userID)
                uProfile.delegate = self
                uProfile.getUserProfile()
                
            }
            
        })
    }
    
    
    
    
    func triggerUpdates() {
        
        guard self.invitableUserArray.count != 0 else { return }
        
        UIView.transition(with: tableView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
        })
    }
}



extension InviteUsersTVC : UserProfileFetcherDelegate {
    
    func userProfileUpdated(userID: String, userProfile: UserProfile) {
        
        self.invitableUserArray.removeAll(where: { $0.userID == userID })
        
        let invitableUser = InvitableUser(userID: userProfile.userID, userName: userProfile.userName, userHandle: userProfile.userHandle, inviteSent: false)
        
        self.invitableUserArray.append(invitableUser)
        
        self.sortUserProfileArray()
        
        self.triggerUpdates()
    }
    
    
}
