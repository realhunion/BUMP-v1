//
//  LoginVC.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/14/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import QuickLayout
import Firebase

class LoginVC: UITableViewController {
    
    var db = Firestore.firestore()
    
    var signupToggled = true {
        didSet {
            self.becomeFirstResponder()
            self.switchView()
        }
    }
    
    deinit {
        print("LOGIN VC is de init")
    }

    var signupView1 : SignupView1 = SignupView1()
    var loginView1 : LoginView1 = LoginView1()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tableView.separatorStyle = .none
        
        signupToggled = true
        
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func shutDown() {
        NotificationCenter.default.removeObserver(self)
        for v in self.view.subviews {
            v.removeFromSuperview()
        }
        self.loginView1.loginVC = nil
        self.signupView1.loginVC = nil
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.signupToggled {
            self.signupView1.center.x = self.view.center.x
            self.signupView1.center.y = (self.view.bounds.height - keyboardFrame.height) / 2
        } else {
            self.loginView1.center.x = self.view.center.x
            self.loginView1.center.y = (self.view.bounds.height - keyboardFrame.height) / 2
        }
        

        UIView.animate(withDuration: Double(exactly: duration) ?? 0 ) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        
        
        if self.signupToggled {
            self.signupView1.center.x = self.view.center.x
            self.signupView1.center.y = self.view.center.y
        } else {
            self.loginView1.center.x = self.view.center.x
            self.loginView1.center.y = self.view.center.y
        }
        
        UIView.animate(withDuration: Double(exactly: duration) ?? 0 ) {
            self.view.layoutIfNeeded()
        }
        
    }
    

    
    func switchToSignupView() {
        self.signupToggled = true
    }
    
    func switchToLoginView() {
        self.signupToggled = false
    }
    
    func switchView() {
        if self.signupToggled {
            
            for x in self.view.subviews {
                x.removeFromSuperview()
            }
            
            let x = self.signupView1
            x.loginVC = self
            let sz = x.systemLayoutSizeFitting(CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
            x.frame.size.height = sz.height
            x.frame.size.width = self.view.bounds.width * 0.8
            self.view.addSubview(x)
            x.center = self.view.center
            
        } else {
            
            for x in self.view.subviews {
                x.removeFromSuperview()
            }
            
            let x = self.loginView1
            x.loginVC = self
            let sz = x.systemLayoutSizeFitting(CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
            x.frame.size.height = sz.height
            x.frame.size.width = self.view.bounds.width * 0.8
            self.view.addSubview(x)
            x.center = self.view.center
            
        }
    }

}
