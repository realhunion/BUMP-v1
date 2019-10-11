//
//  ChatVC+InviteUsers.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/26/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit
import Firebase

extension ChatVC {
    
    
    @objc func handleHeyButton() {
        
        guard !self.checkIfHeyTooFast() else { return }
        
        guard let userProfileDict = UserDefaults.standard.value(forKey: "userProfileDict") as? [String:Any], let userName = userProfileDict["userName"] as? String else { return }
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let text = "🤙"
        
        let messageSender = self.msgSender ?? MessageSender(circleID: circleID, chatID: chatID)
        messageSender.postTextToFirebase(text: text)
        
        let firstName = userName.split(separator: " ")[0]
        
        let msg = Message(userID: myUID, userName: String(firstName), text: text)
        
        
        let x = insertMsgIntoMsgArray(message: msg)
        let indexPath = x.indexPath
        let newSectionCreated = x.newSectionCreated
        
        
        self.collectionView?.performBatchUpdates ({
            
            if newSectionCreated {
                self.collectionView?.insertSections([indexPath.section])
            } else {
                self.collectionView?.insertItems(at: [indexPath])
            }
            
            if indexPath.item-1 >= 0 {
                self.collectionView?.reloadItems(at: [IndexPath (item: indexPath.item - 1, section: indexPath.section)])
            }
            
            self.scrollToBottom(at: .bottom, isAnimated: true)
            
        }, completion: nil)
        
    }
    
    
    
    func checkIfHeyTooFast() -> Bool {
        
        if last3HeyArray.count <= 3 {
            self.last3HeyArray.append(Date())
            return false
        }
        guard let hey1 = last3HeyArray.first else { return false }
        
        
        let lastHeySeconds = Double(hey1.timeIntervalSince1970)
        let currentDate = Date()
        let currentTime = Double(currentDate.timeIntervalSince1970)
        let difference = currentTime - lastHeySeconds
        print("diffff \(difference)")
        if difference < 2 {
            let alert = UIAlertController(title: "Slow down there bud.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return true
        } else {
            self.last3HeyArray.remove(at: 0)
            self.last3HeyArray.append(currentDate)
        }
        
        return false
        
    }
    
    
    
}
