//
//  UserProfileEditView.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/31/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import QuickLayout
import Firebase

public class UserProfileEditView : UIView {
    
    // MARK: Props
    
    var descriptionPlaceholder = "Let your friends know a bit about yourself"
    var namePlaceholder = "Your Name"
    var handlePlaceholder = "Choose a username"
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.borderWidth = 3.0
        
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var imageEditButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        button.setTitle("Edit", for: .normal)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.contentVerticalAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        
        button.layer.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor
        
        button.addTarget(self, action: #selector(imageEditButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    lazy var userNameTextField : UITextField = {
        let textfield = TextField()
        textfield.padding.top = 0
        textfield.padding.bottom = 0
        textfield.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        textfield.placeholder = namePlaceholder
        textfield.textAlignment = .center
        
        textfield.layer.borderColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        textfield.layer.borderWidth = 0.5
        textfield.layer.cornerRadius = 6
        
        textfield.adjustsFontSizeToFitWidth = true
        textfield.autocorrectionType = UITextAutocorrectionType.no
        
        textfield.tag = 0
        
        textfield.delegate = self
        
        return textfield
    }()
    
    
    lazy var userHandleTextField : UITextField = {
        var textfield = TextField()
        textfield.padding.top = 4
        textfield.padding.bottom = 4
        
        textfield.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        textfield.textColor = UIColor.gray
        
        
        textfield.placeholder = handlePlaceholder
        textfield.textAlignment = .center
        
        textfield.layer.borderColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        textfield.layer.borderWidth = 0.5
        textfield.layer.cornerRadius = 6
        
        
        textfield.adjustsFontSizeToFitWidth = true
        textfield.autocorrectionType = UITextAutocorrectionType.no
        textfield.autocapitalizationType = .none
        
        textfield.delegate = self
        
        textfield.tag = 1
        
        return textfield
    }()
    
    lazy var userDescriptionTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        textView.textAlignment = .center
        textView.textColor = Constant.placeholderGray
        textView.text = self.descriptionPlaceholder
        
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        textView.layer.borderColor = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 6
        
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.textContainer.maximumNumberOfLines = 2
        
        textView.delegate = self
        
        return textView
    }()
    
    lazy var actionButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        
        button.backgroundColor = Constant.mBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.setTitle("Save", for: .normal)
        
        return button
    }()

    
    
    let storageRef = Storage.storage()
    let db = Firestore.firestore()
    
    var userID : String!
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image"]
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self
        
        picker.view.layer.cornerRadius = 18.0
        picker.view.clipsToBounds = true
        
        return picker
    }()
    
    // MARK: Setup
    //userImage : UIImage, userName : String, description : String
    public init(userID : String, userImage : UIImage?, userName : String?, userHandle : String?, userDescription : String?) {
        super.init(frame: UIScreen.main.bounds)
        
        self.userID = userID
        if let uImage = userImage {
            self.userImageView.image = uImage
        }
        self.userNameTextField.text = userName
        if let uHandle = userHandle {
            self.userHandleTextField.text = "@" + uHandle
        }
        if let uDescription = userDescription {
            self.userDescriptionTextView.text = uDescription
            self.userDescriptionTextView.textColor = UIColor.gray
        }
        
        setupImageView()
        setupImageEditView()
        setupTitleLabel()
        setupHandleLabel()
        setupDescriptionLabel()
        setupActionButton()
        
        let _ = imagePicker.view
        
        print("EDIT profile View init")
        
    }
    
    deinit {
        print("EDIT userprofileview did deinit")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupImageView() {
        
        addSubview(userImageView)
        userImageView.layoutToSuperview(.centerX)
        userImageView.layoutToSuperview(.top, offset: 30)
        userImageView.set(.width, .height, of: 120)
        
    }
    
    func setupImageEditView() {
        
        userImageView.addSubview(imageEditButton)
        imageEditButton.layoutToSuperview(.top, .left, .bottom, .right, offset: 0)
    }
    
    func setupTitleLabel() {
        
        addSubview(userNameTextField)
        userNameTextField.layoutToSuperview(axis: .horizontally, offset: 30)
        userNameTextField.layout(.top, to: .bottom, of: userImageView, offset: 15)
        userNameTextField.forceContentWrap(.vertically)
    }
    
    func setupHandleLabel() {
        addSubview(userHandleTextField)
        userHandleTextField.layoutToSuperview(axis: .horizontally, offset: 30)
        userHandleTextField.layout(.top, to: .bottom, of: userNameTextField, offset: 6)
        userHandleTextField.forceContentWrap(.vertically)
    }
    
    func setupDescriptionLabel() {
        
        addSubview(userDescriptionTextView)
        userDescriptionTextView.layoutToSuperview(axis: .horizontally, offset: 30)
        userDescriptionTextView.set(.height, of: 48.0)
        userDescriptionTextView.layout(.top, to: .bottom, of: userHandleTextField, offset: 6)
        userDescriptionTextView.forceContentWrap(.vertically)
    }
    
    func setupActionButton() {
        
        addSubview(actionButton)
        let height: CGFloat = 40
        actionButton.set(.height, of: height)
        actionButton.layout(.top, to: .bottom, of: userDescriptionTextView, offset: 10)
        actionButton.layoutToSuperview(.bottom, offset: -30)
        actionButton.layoutToSuperview(.left, offset: 30)
        actionButton.layoutToSuperview(.right, offset: -30)
        actionButton.layoutToSuperview(.centerX)
    }
    
}


