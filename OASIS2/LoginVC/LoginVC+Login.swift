//
//  LoginVC+Login.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/15/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import SwiftEntryKit


extension LoginVC {
    
    
    @objc func loginButtonPressed() {
        
        guard self.loginView1.checkIfFieldsCorrect() else { return }
        guard let email = loginView1.emailTextField.text else { return }
        guard let pass = loginView1.passTextField.text else { return }
        
        self.loginView1.loginButton.setTitle("Logging in...", for: .normal)
        self.loginView1.loginButton.isEnabled = false
        
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, err) in
            
            guard let user = authResult?.user else {
                
                self.loginView1.loginButton.setTitle("Log In", for: .normal)
                self.loginView1.loginButton.isEnabled = true
                
                if let errCode = err?._code {
                    
                    if errCode == AuthErrorCode.userNotFound.rawValue {
                        self.presentAlertView(title: "Account not found.", subtitle: "Try signing up.")
                    }
                    else if errCode == AuthErrorCode.wrongPassword.rawValue {
                        self.presentAlertView(title: "Login failed.", subtitle: "")
                    }
                    else {
                        self.presentAlertView(title: "Login failed.", subtitle: "")
                    }
                    
                } else {
                    self.presentAlertView(title: "Login failed.", subtitle: "")
                }
                
                return
            }
            
            
            self.loginView1.loginButton.setTitle("Log In", for: .normal)
            self.loginView1.loginButton.isEnabled = true
            
            if user.isEmailVerified == false {
                self.presentAlertView(title: "Account not verified.", subtitle: "Check your inbox to verify.")
            } else {
                (UIApplication.shared.delegate as! AppDelegate).setRootVC()
            }
            
            
        }
        
    }
    
    
    
    
    
    
    
}
