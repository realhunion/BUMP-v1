//
//  IncomingTextMessageCell.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import Foundation
import FirebaseStorage
import FirebaseAuth
import SwiftEntryKit

class IncomingTextMessageCell: BaseMessageCell {
    
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 25.0, height: 25.0)
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        imageView.contentMode = ContentMode.scaleAspectFill
        
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    var nameLabel: InsetLabel = {
        let nameLabel = InsetLabel()
        nameLabel.contentInsets = UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 0)
        nameLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .semibold)
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = UIColor.gray
        return nameLabel
    }()
    
    
    func setupCell(message: Message, isImageEnabled: Bool, isUserNameEnabled:Bool) {
        
        textView.text = message.text
        
        if(estimateFrameForText(message.text).width <= Constant.minBubbleWidth) {
            textView.textAlignment = NSTextAlignment.center
        }
        
        if isUserNameEnabled {
            
            nameLabel.text = message.userName
            
            nameLabel.frame.size = CGSize(width: Constant.maxBubbleWidth, height: estimateFrameForText(nameLabel.text!).height)
            nameLabel.frame.origin = CGPoint(x: 10.0 + imageView.bounds.width + 10.0, y: 0)
            
            bubbleView.frame = CGRect(x: 10.0 + imageView.bounds.width + 10.0,
                                      y: nameLabel.frame.height,
                                      width: estimateFrameForText(message.text).width + (Constant.leftRightBubbleSpacing*2),
                                      height: frame.size.height - nameLabel.frame.height).integral
            textView.frame = CGRect(x: 0, y: 0, width: bubbleView.frame.width, height: bubbleView.frame.height)
            
        }
        else {
            bubbleView.frame = CGRect(x: 10.0 + imageView.bounds.width + 10.0,
                                      y: 0,
                                      width: estimateFrameForText(message.text).width + (Constant.leftRightBubbleSpacing*2),
                                      height: frame.size.height).integral
            textView.frame = CGRect(x: 0, y: 0, width: bubbleView.frame.width, height: bubbleView.frame.height)
        }
        
        if isImageEnabled {
            imageView.isHidden = false
            imageView.frame.origin = CGPoint(x: 10.0, y: frame.height-imageView.frame.height)
            
            let imageRef = Storage.storage().reference(withPath: "User-Profile-Images/\(message.userID).jpg")
            
            let placeHolder = UIImage(color: Constant.myGrayColor)
            self.imageView.sd_setImage(with: imageRef, placeholderImage: placeHolder)
            
        } else {
            imageView.isHidden = true
        }
        
    }
    
    
    override func setupViews() {
        super.setupViews()
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(textView)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }
    
    override func prepareViewsForReuse() {
        super.prepareViewsForReuse()
        textView.textAlignment = NSTextAlignment.natural
        textView.text = ""
        nameLabel.text = ""
        imageView.image = nil
        
    }
    
    
    
}













