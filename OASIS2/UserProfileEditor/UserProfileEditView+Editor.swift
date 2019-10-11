//
//  UserProfileEditView+Fetcher.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/31/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SDWebImage
import SwiftEntryKit

extension UserProfileEditView {
    
    
    func loadUserDefaultUserProfile() -> [String:String]?{
        
        let valueDict = UserDefaults.standard.value(forKey: "userProfileDict")
        
        if let value = valueDict as? [String:String], let uImage = value["userImage"], let uName = value["userName"], let uHandle = value["userHandle"], let uDescription = value["userDescription"] {
            
            return ["userImage":uImage,
                    "userName":uName,
                    "userHandle":uHandle,
                    "userDescription":uDescription]
            
        } else {
            return nil
        }
        
    }
    
    func saveUserDefaultUserProfile(userProfile : UserProfile) {
        
        let uProfileDict : [String:String] = ["userImage":userProfile.userImage,
                                              "userName":userProfile.userName,
                                              "userHandle":userProfile.userHandle,
                                              "userDescription":userProfile.userDescription]
        
        UserDefaults.standard.setValue(uProfileDict, forKey: "userProfileDict")
        
    }
    

    @objc func actionButtonPressed() {
        
        guard checkAllFieldsCorrect() else { return }
        
        let oldButtonTitle = self.actionButton.titleLabel?.text
        
        self.actionButton.isEnabled = false
        self.actionButton.setTitle("Saving...", for: .normal)
        
        self.checkIfHandleAvailable(userHandle: userHandleTextField.text!) { (available) in
            guard available else {
                self.userHandleTextField.text = nil
                self.animateTextFieldError(textField: self.userHandleTextField, errorText: "Username already taken.")
                self.actionButton.isEnabled = true
                self.actionButton.setTitle("Save", for: .normal)
                return
            }
            
            self.updateFirebaseProfile {userProfile in
                
                if let uProfile = userProfile {
                    
                    self.saveUserDefaultUserProfile(userProfile: uProfile)
                    SwiftEntryKit.dismiss()
                    
                } else {
                    self.actionButton.isEnabled = true
                    self.actionButton.setTitle("Save", for: .normal)
                    //FIX: error
                }
                
            }
            
        }
        
    }
    
    func presentAlertView(title : String, subtitle : String) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        if let topVC = (UIApplication.topViewController()) {
            topVC.present(alert, animated: true)
        }
        
    }
    
    
    func updateFirebaseProfile(completion:@escaping (_ userProfile : UserProfile?)->Void) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { completion(nil); return }
        
        guard let userImage = self.userImageView.image else { completion(nil); return }
        guard let userName = self.userNameTextField.text else { completion(nil) ; return }
        guard let userHandle = self.userHandleTextField.text else { completion(nil) ; return }
        guard let userDescription = self.userDescriptionTextView.text else { completion(nil) ; return }
        
        var userHandleText = userHandle
        if userHandleText.first == "@" { userHandleText.removeFirst() }
        userHandleText = userHandleText.lowercased()
        
        let dbBatch = db.batch()
        
        let data = ["userName":userName, "userDescription":userDescription, "userHandle":userHandleText] as [String:Any]
        let ref = db.collection("User-Profile").document(myUID)
        dbBatch.setData(data, forDocument: ref, merge: true)
        
        

        let ref2 = db.collection("User-Handle").whereField("userID", isEqualTo: myUID)
        
        ref2.getDocuments { (snap, err) in
            guard let docs = snap?.documents else { return }
            
            for doc in docs {
                if doc.documentID != userHandleText {
                    doc.reference.delete()
                }
            }
        }
        
        
        let data3 = ["userID":myUID]
        let ref3 = db.collection("User-Handle").document(userHandleText)
        dbBatch.setData(data3, forDocument: ref3)
        
        
        self.updateFirebaseUserImage(image: userImage) { (filePath) in
            guard let fileSavePath = filePath else { completion(nil); return }
            
            dbBatch.commit { (err) in
                guard err == nil else { completion(nil); return }
                
                let uProfile = UserProfile(userID: self.userID, userName: userName, userHandle: userHandleText, userImage: fileSavePath, userDescription: userDescription)
                completion(uProfile)
            }
        }
        
    }
    
    
    
    
    func checkAllFieldsCorrect() -> Bool {
        
        guard let userName = self.userNameTextField.text else { return false }
        guard let userHandle = self.userHandleTextField.text else { return false }
        guard let userDescription = self.userDescriptionTextView.text else { return false }
        
        var userHandleText = userHandle
        if userHandleText.first == "@" {
            userHandleText.removeFirst()
        }
        
        var userDescriptionText = userDescription
        if userDescriptionText == self.descriptionPlaceholder {
            userDescriptionText = ""
        }
        
        var allGood = true
        
        if self.userImageView.image == nil {
            self.animateImageViewError(imageView: self.userImageView)
            allGood = false
        }
        
        if userName == "" {
            self.animateTextFieldError(textField: self.userNameTextField, errorText: self.namePlaceholder)
            allGood = false
        }
        else if isAlphaNumericOnly(text: userName, includeSpace: true) {
            self.userNameTextField.text = ""
            self.animateTextFieldError(textField: self.userNameTextField, errorText: "Enter a valid name.")
            allGood = false
        }
        
        if userHandleText == "" {
            self.animateTextFieldError(textField: self.userHandleTextField, errorText: self.handlePlaceholder )
            allGood = false
        }
        else if isAlphaNumericOnly(text: userHandleText, includeSpace: false) {
            self.userHandleTextField.text = ""
            self.animateTextFieldError(textField: self.userHandleTextField, errorText: "Alphanumeric characters only.")
            allGood = false
        }
        
        if userDescription == "" || userDescription == descriptionPlaceholder {
            self.userDescriptionTextView.resignFirstResponder()
            self.animateTextViewError(textView: self.userDescriptionTextView, errorText: self.descriptionPlaceholder)
            allGood = false
        }
        
        return allGood
        
    }
    
    
    func checkIfHandleAvailable(userHandle : String, completion:@escaping (_ allGood : Bool)->Void) {
        
        var userHandleText = userHandle
        if userHandleText.first == "@" { userHandleText.removeFirst() }
        userHandleText = userHandleText.lowercased()
        
        
        db.collection("User-Handle").document(userHandleText).getDocument { (snap, err) in
            guard err == nil else { completion(false); return }
            guard let data = snap?.data() else { print("coup"); completion(true); return }
            
            if let handleUserID = data["userID"] as? String {
                if handleUserID == self.userID {
                    print("coup1")
                    completion(true)
                } else {
                    print("coup2")
                    completion(false)
                }
                
            } else {
                print("coup3")
                completion(true)
            }
        }
        
    }
    
    
    
    
    func isAlphaNumericOnly(text : String, includeSpace : Bool) -> Bool {
        var regEx = ".*[^A-Za-z0-9].*"
        if includeSpace {
            regEx = ".*[^A-Za-z0-9 ].*"
        }
        let textTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return textTest.evaluate(with: text)
    }
    
    
    func animateImageViewError(imageView : UIImageView) {
        
        let animation2:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation2.fromValue = 3.0
        animation2.toValue = imageView.layer.borderWidth
        animation2.duration = 0.4
        imageView.layer.add(animation2, forKey: "borderWidth")
        imageView.layer.borderWidth = imageView.layer.borderWidth
        
        
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.red.cgColor
        animation.toValue = imageView.layer.borderColor
        animation.duration = 0.4
        imageView.layer.add(animation, forKey: "borderColor")
        imageView.layer.borderColor = imageView.layer.borderColor
        
        
    }
    
    
    func animateTextFieldError(textField : UITextField, errorText : String) {
        
        let animation2:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation2.fromValue = 1.0
        animation2.toValue = textField.layer.borderWidth
        animation2.duration = 0.4
        textField.layer.add(animation2, forKey: "borderWidth")
        textField.layer.borderWidth = textField.layer.borderWidth
        
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
    
    
    func animateTextViewError(textView : UITextView, errorText : String) {
        
        let animation2:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation2.fromValue = 1.0
        animation2.toValue = textView.layer.borderWidth
        animation2.duration = 0.4
        textView.layer.add(animation2, forKey: "borderWidth")
        textView.layer.borderWidth = textView.layer.borderWidth
        
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.red.cgColor
        animation.toValue = textView.layer.borderColor
        animation.duration = 0.4
        textView.layer.add(animation, forKey: "borderColor")
        textView.layer.borderColor = textView.layer.borderColor
        
        
        UIView.transition(with: textView, duration: 0.01, options: .transitionCrossDissolve, animations: {
            
            let atr = [NSAttributedString.Key.foregroundColor : UIColor.red,
                       NSAttributedString.Key.font : textView.font ?? UIFont.systemFont(ofSize: 15.0, weight: .medium)]
            textView.attributedText = NSAttributedString(string: errorText, attributes: atr)
            
        }, completion: { (x) in
            
            UIView.transition(with: textView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                
                textView.selectedRange = NSMakeRange(0, 0)
                
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.alignment = .center
                
                let atr = [NSAttributedString.Key.foregroundColor : Constant.placeholderGray,
                NSAttributedString.Key.font : textView.font ?? UIFont.systemFont(ofSize: 15.0, weight: .medium),
                NSAttributedString.Key.paragraphStyle : paraStyle]
                textView.attributedText = NSAttributedString(string: errorText, attributes: atr)
                
            }, completion: nil)
        })
        
        textView.textAlignment = .center
        
        
    }
    
    
}
