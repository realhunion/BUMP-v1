//
//  UserProfileInitView.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/22/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

class UserProfileInitView : UserProfileEditView {
    
    override func actionButtonPressed() {
        
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
                    (UIApplication.shared.delegate as! AppDelegate).oasis?.goOnline()
                    
                } else {
                    self.actionButton.isEnabled = true
                    self.actionButton.setTitle("Save", for: .normal)
                    //FIX: error
                }
                
            }
            
        }
        
    }
    
    override func imageEditButtonPressed() {
        let atr = Constant.fixedPopUpAttributes(heightWidthRatio: 1.0)
        SwiftEntryKit.display(entry: self.imagePicker, using: atr)
        
        
        var attributes = Constant.bottomPopUpAttributes
        attributes.precedence = .enqueue(priority: .normal)
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .absorbTouches
        attributes.scroll = .disabled
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        attributes.positionConstraints.keyboardRelation = keyboardRelation
        SwiftEntryKit.display(entry: self, using: attributes)
    }
    
    
}
