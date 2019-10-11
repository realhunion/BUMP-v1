//
//  AutoFollowView.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/20/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import Firebase

class AutoFollowView: UIView {
    
    var db = Firestore.firestore()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.text = "Autofollow fellow Grinnell classmates?"
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    lazy var yesButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(yesButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        button.setTitle("Yes! Less Work.", for: .normal)
        button.backgroundColor = Constant.mBlue
        return button
    }()
    
    lazy var noButton : UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(noButtonPressed), for: .touchUpInside)
        button.setTitleColor(UIColor.black.withAlphaComponent(1.0), for: .normal)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        button.setTitle("No. I'm fine.", for: .normal)
        button.backgroundColor = Constant.coolestGray
        return button
    }()
    
    lazy var detailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
        label.textColor = UIColor.lightGray
        label.text = "You can change it later in settings."
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        
        setupTitleLabel()
        setupYesButton()
        setupNoButton()
        setupDetailLabel()
        
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
    
    func setupYesButton() {
        
        addSubview(yesButton)
        let height: CGFloat = 40
        yesButton.set(.height, of: height)
        yesButton.layout(.top, to: .bottom, of: titleLabel, offset: 15)
        yesButton.layoutToSuperview(.left, offset: 30)
        yesButton.layoutToSuperview(.right, offset: -30)
        yesButton.layoutToSuperview(.centerX)
    }
    
    func setupNoButton() {
        
        addSubview(noButton)
        let height: CGFloat = 40
        noButton.set(.height, of: height)
        noButton.layout(.top, to: .bottom, of: yesButton, offset: 10)
        noButton.layoutToSuperview(.left, offset: 30)
        noButton.layoutToSuperview(.right, offset: -30)
        noButton.layoutToSuperview(.centerX)
    }
    
    func setupDetailLabel() {
        
        addSubview(detailLabel)
        detailLabel.layout(.top, to: .bottom, of: noButton, offset: 20)
        detailLabel.layoutToSuperview(.left, offset: 30)
        detailLabel.layoutToSuperview(.right, offset: -30)
        detailLabel.layoutToSuperview(.bottom, offset: -30)
    }
    
}
