//
//  UserLookupView+Search.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/28/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import SwiftEntryKit
import Firebase

extension UserLookupView : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text,
            let textRange = Range(range, in: text) else { return false }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if updatedText.first != "@" {
            textField.text = "@"
            return true
        }
        else if updatedText == "@" {
            textField.text = ""
            return false
        } else {
            return true
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchButtonPressed()
        return true
    }
    
    @objc func searchButtonPressed() {
        
        guard let userHandle = textField.text, textField.text != "" else { return }
        
        var userHandleText = userHandle
        if userHandleText.first == "@" { userHandleText.removeFirst() }
        userHandleText = userHandleText.lowercased()
        
        self.textField.isEnabled = false
        self.searchButton.setTitle("Searching...", for: .normal)
        
        self.lookupUserHandle(userHandle: userHandleText) { (userID) in
            guard let uID = userID else {
                
                self.textField.isEnabled = true
                self.searchButton.setTitle("Search", for: .normal)
                self.textField.text = nil
                
                
                self.animateTextFieldError(textField: self.textField, errorText: "User not found. Try again.")
                
                return
            }
            
            
            let profileView = UserProfileView(userID: uID)
            
            let attributes = Constant.bottomPopUpAttributes
            DispatchQueue.main.async {
                SwiftEntryKit.display(entry: profileView, using: attributes)
            }
            
                
            
        }
    }
    
    
    func animateTextFieldError(textField : UITextField, errorText : String) {
        
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.red.cgColor
        animation.toValue = textField.layer.borderColor
        animation.duration = 0.4
        textField.layer.add(animation, forKey: "borderColor")
        textField.layer.borderColor = textField.layer.borderColor
        
        
        UIView.transition(with: textField, duration: 0.01, options: .transitionCrossDissolve, animations: {
            textField.textColor = UIColor.red

            let atr = [NSAttributedString.Key.foregroundColor : UIColor.red]
            textField.attributedPlaceholder = NSAttributedString(string: errorText, attributes: atr)
        }, completion: { (x) in
            UIView.transition(with: textField, duration: 0.4, options: .transitionCrossDissolve, animations: {
                textField.textColor = UIColor.black

                let atr = [NSAttributedString.Key.foregroundColor : Constant.placeholderGray]
                textField.attributedPlaceholder = NSAttributedString(string: errorText, attributes: atr)
            }, completion: nil)
        })
    }
    
    
    
    
    func lookupUserHandle(userHandle : String, completion:@escaping (_ userID : String?)->Void) {
        
        db.collection("User-Handle").document(userHandle).getDocument { (snap, err) in
            guard let data = snap?.data(), let userID = data["userID"] as? String
                else { completion(nil); return }
            
            
            completion(userID)
            
        }
        
    }
    
    
    
    
    
}
