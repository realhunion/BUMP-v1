//
//  AutoFollowView+Action.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/20/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import SwiftEntryKit

extension AutoFollowView {
    
    @objc func yesButtonPressed() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { self.resetButtonUI(); return }
        
        self.yesButton.isEnabled = false
        self.noButton.isEnabled = false
        self.yesButton.setTitle("Following Users...", for: .normal)
        
        db.collection("User-Profile").getDocuments { (snap, err) in
            guard let allDocs = snap?.documents else { self.resetButtonUI(); return }
            
            var autoFollowDocs : [QueryDocumentSnapshot] = []
            for doc in allDocs {
                if let autoFollow = doc.data()["autoFollow"] as? Bool, autoFollow == true {
                    autoFollowDocs.append(doc)
                }
            }
            
            var allUserIDArray = allDocs.map({$0.documentID})
            var autoFollowUserIDArray = autoFollowDocs.map({$0.documentID})
            allUserIDArray = allUserIDArray.filter({$0 != myUID})
            autoFollowUserIDArray = autoFollowUserIDArray.filter({$0 != myUID})
            
            let dbBatch = self.db.batch()
            
            let ref = self.db.collection("User-Profile").document(myUID)
            dbBatch.setData(["autoFollow":true], forDocument: ref, merge: true)
            
            for userID in allUserIDArray {
                let ref1 = self.db.collection("User-Profile").document(myUID).collection("Following").document(userID)
                dbBatch.setData([:], forDocument: ref1)
                
                let ref2 = self.db.collection("User-Profile").document(userID).collection("Followers").document(myUID)
                dbBatch.setData([:], forDocument: ref2)
            }
            
            for userID in autoFollowUserIDArray {
                
                let ref1 = self.db.collection("User-Profile").document(userID).collection("Following").document(myUID)
                dbBatch.setData([:], forDocument: ref1)
                
                let ref2 = self.db.collection("User-Profile").document(myUID).collection("Followers").document(userID)
                dbBatch.setData([:], forDocument: ref2)
                
            }
            
            dbBatch.commit(completion: { (err) in
                guard err == nil else { self.resetButtonUI(); return }
                
                SwiftEntryKit.dismiss()
                
            })
            
        }
    }
    
    @objc func noButtonPressed() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { self.resetButtonUI(); return }
        
        self.yesButton.isEnabled = false
        self.noButton.isEnabled = false
        self.noButton.setTitle("Saving Choice...", for: .normal)
        
        db.collection("User-Profile").document(myUID).setData(["autoFollow":false], merge: true) { (err) in
            guard err == nil else { self.resetButtonUI(); return }
            
            SwiftEntryKit.dismiss()
            
        }
        
    }
    
    func resetButtonUI() {
        self.yesButton.isEnabled = true
        self.noButton.isEnabled = true
        self.yesButton.setTitle("Yes! Less Work.", for: .normal)
        self.noButton.setTitle("No. I'm Fine.", for: .normal)
    }
    
    
    
    
}
