//
//  AddFriendView.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/27/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import QuickLayout
import FirebaseFirestore

class UserLookupView: UIView {
    
    
    var db = Firestore.firestore()
    

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        titleLabel.text = "Look up a Friend"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        return titleLabel
    }()
    
    lazy var textField: TextField = {
        let textField = TextField()
        textField.layer.cornerRadius = 6
        textField.backgroundColor = Constant.coolGray
        textField.placeholder = "Type their user handle"
        textField.textAlignment = NSTextAlignment.center
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 13.0
        
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor
        
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.returnKeyType = .search
        
        textField.delegate = self
        
        return textField
    }()
    
    lazy var searchButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.setTitle("Search", for: .normal)
        button.backgroundColor = Constant.mBlue
        return button
    }()
    
    
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        
        setupTitleLabel()
        setupTextField()
        setupSearchButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupTitleLabel() {
        
        addSubview(titleLabel)
        titleLabel.layoutToSuperview(.top, offset: 30)
        titleLabel.layoutToSuperview(.left, offset: 30)
        titleLabel.layoutToSuperview(.right, offset: -30)
        
    }
    
    func setupTextField() {
        
        addSubview(textField)
        textField.layout(.top, to: .bottom, of: titleLabel, offset: 15)
        textField.layoutToSuperview(.left, offset: 30)
        textField.layoutToSuperview(.right, offset: -30)
        
        let height: CGFloat = 35
        textField.set(.height, of: height)
    }
    
    func setupSearchButton() {
        
        addSubview(searchButton)
        let height: CGFloat = 40
        searchButton.set(.height, of: height)
        searchButton.layout(.top, to: .bottom, of: textField, offset: 10)
        searchButton.layoutToSuperview(.bottom, offset: -30)
        searchButton.layoutToSuperview(.left, offset: 30)
        searchButton.layoutToSuperview(.right, offset: -30)
        searchButton.layoutToSuperview(.centerX)
    }
    

}


class TextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
