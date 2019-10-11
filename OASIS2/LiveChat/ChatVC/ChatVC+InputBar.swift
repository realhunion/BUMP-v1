//
//  ChatVC+MsgSender.swift
//  OASIS2
//
//  Created by Honey on 5/31/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftEntryKit

extension ChatVC {
    
    @objc func handleSend() {
        
        guard let userProfileDict = UserDefaults.standard.value(forKey: "userProfileDict") as? [String:Any], let userName = userProfileDict["userName"] as? String else { return }
    
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        guard let text = inputBarView.inputTextView.text else { return }
        
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        inputBarView.prepareForSend()
        
        let messageSender = self.msgSender ?? MessageSender(circleID: circleID, chatID: chatID)
        messageSender.postTextToFirebase(text: trimmedText)
        
        let firstName = userName.split(separator: " ")[0]
    
        let msg = Message(userID: myUID, userName: String(firstName), text: trimmedText)
        
        
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
    
    
    
    
    
    
    
    // MARK: - Screen Tap Gestures
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    @objc func screenTapped() {
        self.inputBarView.inputTextView.resignFirstResponder()
    }
    
    
    
    
    
    
    
    //MARK: - Keyboard & Content Offset & Constraints Movement
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue ?? 0
        
        inputBarBottomAnchor?.constant = -keyboardFrame!.height + view.safeAreaInsets.bottom
        collectionView?.contentInset = UIEdgeInsets(top: 44+47+10, left: 0, bottom: self.inputBarHeight + 10, right: 0)
        
        UIView.animate(withDuration: keyboardDuration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.scrollToBottom(at: .bottom, isAnimated: true)
        }, completion: { (completed) in})
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue ?? 0
        
        inputBarBottomAnchor?.constant = 0
        collectionView?.contentInset = UIEdgeInsets(top: 44+47+10, left: 0, bottom: 10, right: 0)
        UIView.animate(withDuration: keyboardDuration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.scrollToBottom(at: .bottom, isAnimated: true)
        }, completion: { (completed) in})
    }
    
    
    
}
