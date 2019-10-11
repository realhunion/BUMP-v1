//
//  LoginVC+Signup.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/17/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

extension LoginVC {
    
    
    @objc func signupButtonPressed() {
        
        guard signupView1.checkIfFieldsCorrect() else { return }
        guard let name = signupView1.nameTextField.text else { return }
        guard let email = signupView1.emailTextField.text else { return }
        guard let pass = signupView1.passTextField.text else { return }
        
        signupView1.signupButton.setTitle("Signing up...", for: .normal)
        Auth.auth().createUser(withEmail: email, password: pass) { (authResult, err) in
            
            guard let user = authResult?.user else {
                
                self.signupView1.signupButton.setTitle("Sign Up!", for: .normal)

                if let errCode = err?._code, errCode == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.presentAlertView(title: "Email is already in use.", subtitle: "Try logging in.")
                } else {
                    self.presentAlertView(title: "Sign up failed.", subtitle: "")
                }
                
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            self.db.collection("User-Profile").document(user.uid).setData(["userName":name], completion: { (err) in
                dispatchGroup.leave()
            })

            dispatchGroup.enter()
            user.sendEmailVerification(completion: { (err) in
                dispatchGroup.leave()
            })
            
            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                
                self.signupView1.signupButton.setTitle("Sign Up!", for: .normal)
                
                self.presentAlertView(title: "Email Sent!", subtitle: "Check your inbox to verify account.")
                
                self.signupView1.emailTextField.text = nil
                self.signupView1.nameTextField.text = nil
                self.signupView1.passTextField.text = nil
                
                self.loginView1.emailTextField.text = email
                self.loginView1.passTextField.text = nil
                
                self.signupToggled = false
            })
            
        }
        
    }
    
    
    func presentAlertView(title : String, subtitle : String) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }


}
