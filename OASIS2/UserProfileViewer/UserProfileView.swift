//
//  UserProfileView.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/17/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import QuickLayout
import Firebase

public class UserProfileView : UIView {
    
    // MARK: Props
    lazy var optionsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(optionsButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitle("...", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(color: Constant.myGrayColor)
        return imageView
    }()
    
    lazy var userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "loading ..."
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var userHandleLabel : UILabel = {
        let label = UILabel()
        label.text = "loading ..."
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var userDescriptionLabel : UILabel = {
        let label = UILabel()
        label.text = "loading ..."
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var actionButton : UIButton = {
        let actionButton = UIButton()
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        actionButton.layer.cornerRadius = 10
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        actionButton.setTitleColor(UIColor.white.withAlphaComponent(1.0), for: .normal)
        actionButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        actionButton.backgroundColor = Constant.myGrayColor
        
        actionButton.isEnabled = false
        return actionButton
    }()
    
    var userProfileFetcher : UserProfileFetcher?
    var userID : String!
    var actionButtonEnabled : Bool = true
    var userProfile : UserProfile?
    
    let storageRef = Storage.storage()
    let db = Firestore.firestore()
    
    // MARK: Setup
    //userImage : UIImage, userName : String, description : String
    public init(userID : String, buttonEnabled : Bool = true) {
        super.init(frame: UIScreen.main.bounds)
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        guard userID != "" else { return }
        
        self.userID = userID
        self.actionButtonEnabled = buttonEnabled
        

        setupOptionsButton()
        setupImageView()
        setupTitleLabel()
        setupUserHandleLabel()
        setupDescriptionLabel()
        setupActionButton()
        
        print("profile View init")
        
        self.userProfileFetcher = UserProfileFetcher(userID: userID)
        self.userProfileFetcher?.delegate = self
        self.userProfileFetcher?.getUserProfile()
        
        self.updateFollowButton(userID: userID)
        
    }
    
    deinit {
        print("userprofileview did deinit")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupOptionsButton() {
        addSubview(optionsButton)
        optionsButton.set(.height, of: 40)
        optionsButton.set(.width, of: 40)
        optionsButton.layoutToSuperview(.top, offset: 0)
        optionsButton.layoutToSuperview(.right, offset: -10)
    }
    
    func setupImageView() {
        
        addSubview(userImageView)
        userImageView.layoutToSuperview(.centerX)
        userImageView.layoutToSuperview(.top, offset: 30)
        userImageView.set(.width, .height, of: 120)
        
    }
    
     func setupTitleLabel() {
        
        addSubview(userNameLabel)
        userNameLabel.layoutToSuperview(axis: .horizontally, offset: 30)
        userNameLabel.layout(.top, to: .bottom, of: userImageView, offset: 15)
        userNameLabel.forceContentWrap(.vertically)
    }
    
    func setupUserHandleLabel() {
        addSubview(userHandleLabel)
        userHandleLabel.layoutToSuperview(axis: .horizontally, offset: 30)
        userHandleLabel.layout(.top, to: .bottom, of: userNameLabel, offset: 2)
        userHandleLabel.forceContentWrap(.vertically)
    }
    
     func setupDescriptionLabel() {
        
        addSubview(userDescriptionLabel)
        userDescriptionLabel.layoutToSuperview(axis: .horizontally, offset: 30)
        userDescriptionLabel.layout(.top, to: .bottom, of: userHandleLabel, offset: 15)
        userDescriptionLabel.forceContentWrap(.vertically)
        
        if self.actionButtonEnabled == false {
            userDescriptionLabel.layoutToSuperview(.bottom, offset: -30)
        }
    }
    
     func setupActionButton() {
        
        guard self.actionButtonEnabled == true else { return }
        
        addSubview(actionButton)
        let height: CGFloat = 40
        actionButton.set(.height, of: height)
        actionButton.layout(.top, to: .bottom, of: userDescriptionLabel, offset: 20)
        actionButton.layoutToSuperview(.bottom, offset: -30)
        actionButton.layoutToSuperview(.left, offset: 30)
        actionButton.layoutToSuperview(.right, offset: -30)
        actionButton.layoutToSuperview(.centerX)
    }
    
    
    
    
    
    
    
    
    
    
    func setButtonUIToFollow() {
        actionButton.isEnabled = true
        actionButton.backgroundColor = Constant.mBlue
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        actionButton.setTitle("Follow", for: .normal)
    }
    func setButtonUIToTryFollowing() {
        actionButton.isEnabled = false
        actionButton.backgroundColor = Constant.mBlue
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        actionButton.setTitle("Following...", for: .normal)
    }
    func setButtonUIToFollowing() {
        actionButton.isEnabled = true
        actionButton.backgroundColor = Constant.chillGreen
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        actionButton.setTitle("Following", for: .normal)
    }
    func setButtonUIToTryUnFollowing() {
        actionButton.isEnabled = false
        actionButton.backgroundColor = Constant.chillGreen
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        actionButton.setTitle("Unfollowing...", for: .normal)
    }
    func setButtonUIToEdit() {
        actionButton.isEnabled = true
        actionButton.backgroundColor = Constant.coolGray
        actionButton.setTitleColor(UIColor.black, for: .normal)
        actionButton.setTitleColor(UIColor.black.withAlphaComponent(0.6), for: .highlighted)
        actionButton.setTitle("Edit", for: .normal)
    }
    func setButtonUIToBlockedByYou() {
        actionButton.isEnabled = true
        actionButton.backgroundColor = Constant.myBlackColor
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.setTitle("Blocked", for: .normal)
    }
    func setButtonUIToUnBlocking() {
        actionButton.isEnabled = true
        actionButton.backgroundColor = Constant.myBlackColor
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.setTitle("Unblocking...", for: .normal)
    }
    func setButtonUIToBlockedByThem() {
        actionButton.isEnabled = false
        actionButton.backgroundColor = UIColor.clear
        actionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        actionButton.setTitleColor(UIColor.gray, for: .normal)
        actionButton.setTitle("You are blocked from following this profile.", for: .normal)
    }
    
}


