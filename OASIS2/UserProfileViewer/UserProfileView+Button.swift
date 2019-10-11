//
//  UserProfileView+Follow.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/18/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import SwiftEntryKit

extension UserProfileView {
    
    
    
    @objc func optionsButtonPressed() {
        
        let v = UserBlockerReporterView(userID: self.userID, userName: self.userNameLabel.text ?? "user")
        var atr = Constant.centerPopUpAttributes
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        atr.positionConstraints.keyboardRelation = keyboardRelation
        
        SwiftEntryKit.display(entry: v, using: atr)
        
    }
    
    
    func updateFollowButton(userID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        if myUID == userID {
            self.setButtonUIToEdit()
            return
        }
        
        var isBlocked = false
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        db.collection("User-Profile").document(userID).collection("Blocked").getDocuments { (snap, err) in
            guard let docs = snap?.documents else { dispatchGroup.leave(); return }
            let userIDArray = docs.map({$0.documentID})
            if userIDArray.contains(myUID) {
                isBlocked = true
                self.setButtonUIToBlockedByThem()
                return
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        db.collection("User-Profile").document(myUID).collection("Blocked").getDocuments { (snap, err) in
            guard let docs = snap?.documents else { dispatchGroup.leave(); return }
            let userIDArray = docs.map({$0.documentID})
            if userIDArray.contains(userID) {
                isBlocked = true
                self.setButtonUIToBlockedByYou()
                return
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            
            guard isBlocked == false else { return }
            
            self.db.collection("User-Profile").document(myUID).collection("Following").getDocuments { (snap, err) in
                guard let docs = snap?.documents else { return }
                
                let usersFollowing = docs.map { $0.documentID }
                
                if usersFollowing.contains(userID) {
                    self.setButtonUIToFollowing()
                }
                else {
                    self.setButtonUIToFollow()
                }
            }
            
        })
    }
    
    
    func followUserFirebase(userID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.setButtonUIToTryFollowing()
        
        let dbBatch = db.batch()
        
        let ref1 = db.collection("User-Profile").document(myUID).collection("Following").document(userID)
        dbBatch.setData([:], forDocument: ref1)
        
        let ref2 = db.collection("User-Profile").document(userID).collection("Followers").document(myUID)
        dbBatch.setData([:], forDocument: ref2)
        
        dbBatch.commit { (err) in
            guard err == nil else { self.setButtonUIToFollow(); return }
            
            self.setButtonUIToFollowing()
            
        }
        
    }
    
    func unFollowUserFirebase(userID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.setButtonUIToTryUnFollowing()
        
        let dbBatch = db.batch()
        
        let ref1 = db.collection("User-Profile").document(myUID).collection("Following").document(userID)
        dbBatch.deleteDocument(ref1)
        
        let ref2 = db.collection("User-Profile").document(userID).collection("Followers").document(myUID)
        dbBatch.deleteDocument(ref2)
        
        dbBatch.commit { (err) in
            guard err == nil else { self.setButtonUIToFollowing(); return }
            
            self.setButtonUIToFollow()
            
        }
        
    }
    
    func unBlockUserFirebase(userID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let isBlockByMe = self.actionButton.titleLabel?.text == "Blocked"
        
        self.setButtonUIToUnBlocking()
        
        db.collection("User-Profile").document(myUID).collection("Blocked").document(userID).delete { (err) in
            guard err == nil else {
                if isBlockByMe {
                    self.setButtonUIToBlockedByYou()
                } else {
                    self.setButtonUIToBlockedByThem()
                }
                return
            }
            
            self.setButtonUIToFollow()
        }
        
    }
    
    
    
    
    
    @objc func actionButtonPressed() {
        guard let text = actionButton.titleLabel?.text else { return }
        if text == "Follow" {
            self.followUserFirebase(userID: self.userID)
        }
        
        if text == "Following" {
            self.unFollowUserFirebase(userID: self.userID)
        }
        
        if text == "Blocked" {
            self.unBlockUserFirebase(userID : self.userID)
        }
        
        if text == "Edit" {
            
            guard let uProfile = self.userProfile else { return }
            
            let uProfileEditViewer = UserProfileEditView(userID: uProfile.userID, userImage: self.userImageView.image, userName: uProfile.userName, userHandle: uProfile.userHandle, userDescription: uProfile.userDescription)
            
            
            var attributes = Constant.bottomPopUpAttributes
            let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
            let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
            attributes.positionConstraints.keyboardRelation = keyboardRelation

            DispatchQueue.main.async {
                SwiftEntryKit.display(entry: uProfileEditViewer, using: attributes)
            }
            
        }
    }
    
    
    
}


