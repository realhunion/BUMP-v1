//
//  LoginView1.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/15/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//


import UIKit
import QuickLayout

class LoginView1: UIView {
    
    deinit {
        print("boop deinit loginview1")
    }
    
    public var loginVC : LoginVC?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "OASIS"
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        
        return label
    }()
    
    lazy var emailTextField: TextField = {
        let textField = TextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.coolestGray
        textField.placeholder = "Your Email"
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 11.0
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor
        
        textField.keyboardType = UIKeyboardType.alphabet
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        
        textField.delegate = self
        
        return textField
    }()
    
    lazy var passTextField: TextField = {
        let textField = TextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.coolestGray
        textField.placeholder = "Password"
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 11.0
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor
        
        textField.keyboardType = UIKeyboardType.alphabet
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.isSecureTextEntry = true
        
        textField.delegate = self
        
        return textField
    }()
    
    lazy var signupButton : UIButton = {
        
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets.right = 10
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(switchToSignupView), for: .touchUpInside)
        button.setTitleColor(Constant.oBlueDark.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(Constant.oBlueDark.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.setTitle("Sign Up", for: .normal)
        return button
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = Constant.mBlue
        return button
    }()
    
    
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        
        setupTitleLabel()
        setupLoginButton()
        setupEmailTextField()
        setupPassTextField()
        setupSignupButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setupTitleLabel() {
        
        addSubview(titleLabel)
        titleLabel.layoutToSuperview(.top, offset: 0)
        titleLabel.layoutToSuperview(.left, offset: 0)
        
        
    }
    
    func setupSignupButton() {
        
        addSubview(signupButton)
        signupButton.layoutToSuperview(.top, offset: 0)
        signupButton.layoutToSuperview(.right, offset: 0)
    }
    
    
    func setupEmailTextField() {
        
        addSubview(emailTextField)
        emailTextField.layout(.top, to: .bottom, of: signupButton, offset: 10)
        emailTextField.layout(.top, to: .bottom, of: titleLabel, offset: 10)
        emailTextField.layoutToSuperview(.left, offset: 0)
        emailTextField.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 35
        emailTextField.set(.height, of: height)
    }
    
    func setupPassTextField() {
        
        addSubview(passTextField)
        passTextField.layout(.top, to: .bottom, of: emailTextField, offset: 10)
        passTextField.layoutToSuperview(.left, offset: 0)
        passTextField.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 35
        passTextField.set(.height, of: height)
    }
    
    func setupLoginButton() {
        addSubview(loginButton)
        loginButton.layout(.top, to: .bottom, of: passTextField, offset: 10)
        loginButton.layoutToSuperview(.bottom, offset: 0)
        loginButton.layoutToSuperview(.left, offset: 0)
        loginButton.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 40
        loginButton.set(.height, of: height)
    }
    
    
    
    
    
    
    @objc func loginButtonPressed() {
        self.loginVC?.loginButtonPressed()
    }
    
    @objc func switchToSignupView() {
        self.loginVC?.switchToSignupView()
    }
    
    
    
    
    
    
    
    
    func checkIfFieldsCorrect() -> Bool {
        
        guard let email = self.emailTextField.text else { return false }
        guard let pass = self.passTextField.text else { return false }
        
        
        var allGood = true
        
        if email == "" {
            self.animateTextFieldError(textField: self.emailTextField, errorText: "Your Email")
            allGood = false
        }
        else if isValidEmail(emailID: email) == false {
            self.emailTextField.text = nil
            self.animateTextFieldError(textField: self.emailTextField, errorText: "Please enter a valid email")
            allGood = false
        }
        
        if pass == "" {
            self.animateTextFieldError(textField: self.passTextField, errorText: "Password")
            allGood = false
        }
        
        return allGood
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
    
    
    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
}



extension LoginView1 : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
