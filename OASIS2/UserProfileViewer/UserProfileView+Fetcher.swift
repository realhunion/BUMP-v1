//
//  UserProfileView+Fetcher.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/18/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import FirebaseUI

extension UserProfileView : UserProfileFetcherDelegate {
    
    
    func userProfileUpdated(userID: String, userProfile: UserProfile) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        self.userProfile = userProfile
        
        let imageRef = self.storageRef.reference(withPath: userProfile.userImage)
        let placeHolder = UIImage(color: Constant.myGrayColor)
        self.userImageView.sd_setImage(with: imageRef, placeholderImage: placeHolder)
        
        
        self.userHandleLabel.text = "@" + userProfile.userHandle
        
        self.userNameLabel.text = userProfile.userName
        
        self.userDescriptionLabel.text = userProfile.userDescription
        
        
        self.actionButton.isEnabled = true
        
        if userID != myUID {
            self.optionsButton.isHidden = false
            self.optionsButton.isEnabled = true
        }
        
    }
    
}
