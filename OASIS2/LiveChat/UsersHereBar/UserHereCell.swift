//
//  UserHereCell.swift
//  OASIS2
//
//  Created by Honey on 7/11/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class UserHereCell: UICollectionViewCell {
    
    let storageRef = Storage.storage()
    
    var userImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(color: Constant.myGrayColor)
        imageView.contentMode = ContentMode.scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutCell() {
        self.addSubview(userImageView)
        userImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        userImageView.layer.cornerRadius = self.frame.width/2
        userImageView.clipsToBounds = true
    }
    
    func updateUserImage(userID : String) {
        
        let imageRef = self.storageRef.reference(withPath: "User-Profile-Images/\(userID).jpg")
        
        let placeHolder = UIImage(color: Constant.myGrayColor)
        self.userImageView.sd_setImage(with: imageRef, placeholderImage: placeHolder)
        
    }
    
    
    
    
}
