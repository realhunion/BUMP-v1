//
//  UserBlockerView+Action.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/21/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import SwiftEntryKit

extension UserBlockerReporterView {
    
    @objc func reportButtonPressed() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { SwiftEntryKit.dismiss(); return }
        
        
        self.setUIToReporting()
        
        let data = ["timestamp" : FieldValue.serverTimestamp(),
                    "reason": self.textField.text ?? ""] as [String : Any]
        
        let ref = db.collection("User-Reports").document(self.userID).collection("Reported").document(myUID)
        ref.setData(data) { (err) in
            guard err == nil else {
                self.resetUI()
                return
            }
            
            let v = UserProfileView(userID: self.userID)
            let atr = Constant.bottomPopUpAttributes
            SwiftEntryKit.display(entry: v, using: atr)
        }
    }
        
        
        
    
    @objc func blockButtonPressed() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { SwiftEntryKit.dismiss(); return }
        
        self.setUIToBlocking()

        let dbBatch = db.batch()

        let ref1 = db.collection("User-Profile").document(myUID).collection("Blocked").document(self.userID)
        dbBatch.setData([:], forDocument: ref1)

        let ref2 = db.collection("User-Profile").document(myUID).collection("Following").document(self.userID)
        dbBatch.deleteDocument(ref2)

        let ref3 = db.collection("User-Profile").document(myUID).collection("Followers").document(self.userID)
        dbBatch.deleteDocument(ref3)

        let ref4 = db.collection("User-Profile").document(self.userID).collection("Following").document(myUID)
        dbBatch.deleteDocument(ref4)

        let ref5 = db.collection("User-Profile").document(self.userID).collection("Followers").document(myUID)
        dbBatch.deleteDocument(ref5)
        
        let ref6 = db.collection("User-Reports").document(self.userID).collection("Blocked").document(myUID)
        let data = ["timestamp" : FieldValue.serverTimestamp(),
                    "reason": self.textField.text ?? ""] as [String : Any]
        dbBatch.setData(data, forDocument: ref6)

        dbBatch.commit { (err) in
            guard err == nil else {
                self.resetUI()
                return
            }

            let v = UserProfileView(userID: self.userID)
            let atr = Constant.bottomPopUpAttributes
            SwiftEntryKit.display(entry: v, using: atr)

        }
    
    }
    
    
    
    
    @objc func cancelButtonPressed() {
        
        let v = UserProfileView(userID: self.userID)
        let atr = Constant.bottomPopUpAttributes
        SwiftEntryKit.display(entry: v, using: atr)
        
    }
    
    
    
    
    
    
    
    func setUIToReporting() {
        
        self.reportButton.isEnabled = false
        self.blockButton.isEnabled = false
        
        self.reportButton.setTitle("Reporting User...", for: .normal)
        
    }
    
    func setUIToBlocking() {
        
        self.reportButton.isEnabled = false
        self.blockButton.isEnabled = false
        
        self.blockButton.setTitle("Blocking User...", for: .normal)
        
    }
    
    func resetUI() {
        
        self.reportButton.isEnabled = true
        self.blockButton.isEnabled = true
        
        self.reportButton.setTitle("Report User", for: .normal)
        self.reportButton.setTitle("Block User", for: .normal)
        
    }
    
    
    
}
