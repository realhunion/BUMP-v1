//
//  SignupView1.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/14/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import QuickLayout
import SwiftEntryKit

class SignupView1: UIView {

    
    public var loginVC : LoginVC?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "OASIS"
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        
        return label
    }()
    
    lazy var nameTextField: TextField = {
        let textField = TextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.coolestGray
        textField.placeholder = "Your Name"
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor

        textField.keyboardType = UIKeyboardType.alphabet
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.words
        
        textField.delegate = self
        
        return textField
    }()
    
    lazy var emailTextField: TextField = {
        let textField = TextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.coolestGray
        textField.placeholder = "Your .edu email"
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = true
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
        textField.placeholder = "Choose a Password"
        textField.textAlignment = NSTextAlignment.left
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor
        
        textField.keyboardType = UIKeyboardType.alphabet
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
//        textField.isSecureTextEntry = true
        
        textField.delegate = self
        
        return textField
    }()
    
    lazy var signupButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.setTitle("Sign Up!", for: .normal)
        button.backgroundColor = Constant.mBlue
        return button
    }()
    
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets.right = 10
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .right
                button.addTarget(self, action: #selector(switchToLoginView), for: .touchUpInside)
        button.setTitleColor(Constant.oBlueDark.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(Constant.oBlueDark.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.setTitle("Log In", for: .normal)
        return button
    }()
    
    lazy var detailLabel : UILabel = {
        let label = UILabel()
        label.text = "Open to Grinnell Students only."
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .medium)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var privacyButton : UIButton = {
        let button = UIButton()
        button.setTitle("Privacy & Terms Of Use", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: .medium)
        button.setTitleColor(Constant.oBlueMedium.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(Constant.oBlueMedium.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.textAlignment = .center
        
        button.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        
        setupTitleLabel()
        setupLoginButton()
        setupNameTextField()
        setupEmailTextField()
        setupPassTextField()
        setupSignupButton()
        setupDetailLabel()
        setupPrivacyButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupTitleLabel() {
        
        addSubview(titleLabel)
        titleLabel.layoutToSuperview(.top, offset: 0)
        titleLabel.layoutToSuperview(.left, offset: 0)
        
    }
    
    func setupLoginButton() {
        addSubview(loginButton)
        
        loginButton.layout(.left, to: .right, of: titleLabel, offset: 10)
        
        loginButton.layoutToSuperview(.top, offset: 0)
        loginButton.layoutToSuperview(.right, offset: 0)
    }
    
    func setupNameTextField() {
        
        addSubview(nameTextField)
        nameTextField.layout(.top, to: .bottom, of: loginButton, offset: 10)
        nameTextField.layout(.top, to: .bottom, of: titleLabel, offset: 10)
        nameTextField.layoutToSuperview(.left, offset: 0)
        nameTextField.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 35
        nameTextField.set(.height, of: height)
    }
    
    func setupEmailTextField() {
        
        addSubview(emailTextField)
        emailTextField.layout(.top, to: .bottom, of: nameTextField, offset: 10)
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
    
    func setupSignupButton() {
        
        addSubview(signupButton)
        signupButton.layout(.top, to: .bottom, of: passTextField, offset: 10)
        signupButton.layoutToSuperview(.left, offset: 0)
        signupButton.layoutToSuperview(.right, offset: 0)
        
        let height: CGFloat = 40
        signupButton.set(.height, of: height)
    }
    
    func setupDetailLabel() {
        
        addSubview(detailLabel)
        detailLabel.layout(.top, to: .bottom, of: signupButton, offset: 20)
        detailLabel.layoutToSuperview(.left, offset: 0)
        detailLabel.layoutToSuperview(.right, offset: 0)
        
    }
    
    func setupPrivacyButton() {
        addSubview(privacyButton)
        
        privacyButton.layout(.top, to: .bottom, of: detailLabel, offset: 0)
        
        privacyButton.layoutToSuperview(.right, offset: 0)
        privacyButton.layoutToSuperview(.left, offset: 0)
        privacyButton.layoutToSuperview(.bottom, offset: 0)
    }
    
    
    
    
    
    
    
    @objc func signupButtonPressed() {
        self.loginVC?.signupButtonPressed()
        
    }
    
    @objc func switchToLoginView() {
        self.loginVC?.switchToLoginView()
    }
    
    @objc func privacyButtonTapped() {
        self.emailTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        self.passTextField.resignFirstResponder()
        let infoView = InfoTextView(text: Constant.privacyInfo)
        let attributes = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)
        SwiftEntryKit.display(entry: infoView, using: attributes)
    }
        
    
    
    
    
    
    
    
    
    func checkIfFieldsCorrect() -> Bool {
        
        guard let name = self.nameTextField.text else { return false }
        guard let email = self.emailTextField.text else { return false }
        guard let pass = self.passTextField.text else { return false }
        
        var allGood = true
        
        if name == "" {
            self.animateTextFieldError(textField: self.nameTextField, errorText: self.nameTextField.placeholder ?? "Your Name")
            allGood = false
        }
        else if isAlphaNumericOnly(text: name, includeSpace: true) {
            self.nameTextField.text = ""
            self.animateTextFieldError(textField: self.nameTextField, errorText: "Enter a valid name.")
            allGood = false
        }
        
        if email == "" {
            self.animateTextFieldError(textField: self.emailTextField, errorText: self.emailTextField.placeholder ?? "Your .edu Email")
            allGood = false
        }
        else if isValidEmail(emailID: email) == false {
            self.emailTextField.text = nil
            self.animateTextFieldError(textField: self.emailTextField, errorText: "Please enter a valid email.")
            allGood = false
        }
        else if isSchoolEmail(emailID: email) == false {
            self.emailTextField.text = nil
            self.animateTextFieldError(textField: self.emailTextField, errorText: "Please enter your .edu email")
            allGood = false
        }
        
        if pass == "" {
            self.animateTextFieldError(textField: self.passTextField, errorText: self.passTextField.placeholder ?? "Choose any password")
            allGood = false
        }
        else if pass.count < 6 {
            self.passTextField.text = nil
            self.animateTextFieldError(textField: self.passTextField, errorText: "Choose a stronger password.")
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
    
    func isSchoolEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@grinnell.edu"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    func isAlphaNumericOnly(text : String, includeSpace : Bool) -> Bool {
        var regEx = ".*[^A-Za-z0-9].*"
        if includeSpace {
            regEx = ".*[^A-Za-z0-9 ].*"
        }
        let textTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return textTest.evaluate(with: text)
    }
    
}



extension SignupView1 : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
