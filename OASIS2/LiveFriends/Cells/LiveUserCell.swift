//
//  LiveUserCell.swift
//  OASIS2
//
//  Created by Honey on 5/23/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import LayoutKit
import Firebase

class LiveUserCell: UITableViewCell {
    
    var storageRef = Storage.storage()
    
    var initialized : Bool = false
    
    lazy var userImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(color: Constant.myGrayColor)
        return imageView
    }()
    lazy var userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "---------------------------------------------------------------------------"
        return label
    }()
    lazy var inCircleLabel : UILabel = {
        let label = UILabel()
        label.text = "---------------------------------------------------------------------------"
        return label
    }()
    lazy var inCircleWithLabel : UILabel = {
        let label = UILabel()
        label.text = "---------------------------------------------------------------------------"
        return label
    }()
    lazy var fullLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.adjustsFontSizeToFitWidth = true
        label.font = self.detailTextLabel?.font
        label.textColor = UIColor.lightGray
        label.text = "Full"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    
    func layoutCell() {
        
        let userNameLabel = LabelLayout(text: self.userNameLabel.text ?? "a friend",
                                        font: UIFont(name: "AvenirNext-DemiBold", size: 17.5)!, numberOfLines: 1, viewReuseId: "userNameLabel",
                                        config: { label in
                                            label.textColor = Constant.myBlackColor
                                            
                                            self.userNameLabel = label
        })
        
        let inCircleLabel = LabelLayout(text: self.inCircleLabel.text ?? "having network problems",
                                        font: UIFont(name: "AvenirNext-DemiBold", size: 13.0)!,
                                        numberOfLines: 1, viewReuseId: "inCircleLabel",
                                        config: { label in
                                            label.textColor = UIColor.lightGray
                                            self.inCircleLabel = label
        })
        
        let inCircleWithLabel = LabelLayout(text: self.inCircleWithLabel.text ?? "by themselves",
                                            font: UIFont(name: "AvenirNext-DemiBold", size: 13.0)!, numberOfLines: 1, viewReuseId: "inCircleWithLabel",
                                            config: { label in
                                                //TEAL BLUE label.textColor = UIColor(red:0.00, green:0.74, blue:0.83, alpha:1.0)
                                                //BLUE LIGHTER = UIColor(red:0.15, green:0.70, blue:0.96, alpha:1.0)
                                                label.textColor = Constant.oBlueDark //Perfect Blue
                                                //label.textColor = Constant.oBlue
                                                self.inCircleWithLabel = label
                                                
        })
        
        
        let verticalLabelStack =
            StackLayout(
                axis: .vertical,
                spacing: 0,
                alignment: Alignment(vertical: .center, horizontal: .fill),
                sublayouts: [userNameLabel,
                             inCircleLabel,
                             inCircleWithLabel]
        )
        
        
        let sideSize : CGFloat = 50.0
        let profileImageView = SizeLayout<UIImageView>(
            size: CGSize(width: sideSize, height: sideSize),
            viewReuseId: "profileImage",
            config: { imageView in
                
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = sideSize/2
                imageView.clipsToBounds = true
                
                self.userImageView = imageView
                
        })
        
        
        
        let button = ButtonLayout(type: .custom, title: "Join", image: ButtonLayoutImage.size(CGSize(width: 10, height: 28)), alignment: Alignment(vertical: .center, horizontal: .trailing), flexibility: .min) { (b) in
            
            b.titleLabel?.textColor = UIColor.white
            
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 13.0)!, NSAttributedString.Key.foregroundColor: UIColor.white ]
            let myAttrString = NSAttributedString(string: "Join", attributes: myAttribute)
            b.titleLabel?.attributedText = myAttrString
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: b.frame.width, height: b.frame.height)
            //blue-purple
            var color1: UIColor = UIColor(red:0.00, green:0.41, blue:1.00, alpha:1.0)
            var color2: UIColor = UIColor(red:0.02, green:0.61, blue:1.00, alpha:1.0)
            
            gradientLayer.colors = [color1.cgColor, color2.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.frame = b.bounds
            b.layer.insertSublayer(gradientLayer, at: 0)
            
            gradientLayer.cornerRadius = 10
            b.layer.cornerRadius = 10
            
            b.contentVerticalAlignment = .center
            b.titleLabel?.textAlignment = .center
            
            b.layer.masksToBounds = true
        }
        
//        self.accessoryType = .disclosureIndicator
//        self.detailTextLabel?.text = "2/7"
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        
        let stack = StackLayout(axis: .horizontal, spacing: 12, alignment: Alignment(vertical: .center, horizontal: .fill), sublayouts: [profileImageView, verticalLabelStack])
        
        let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let insetLayout = InsetLayout(insets: insets, sublayout: stack)
        
        insetLayout.arrangement(origin: self.contentView.frame.origin, width: self.contentView.frame.width, height: self.contentView.frame.height).makeViews(in: self.contentView)
        
        initialized = true
    }
    
    func setupCell(userImageString: String, userName: String, inCircleName: String, inCircleWith: String?, inCircleWithCount : Int) {
        
        self.userImageView.image = nil
        self.userNameLabel.text = nil
        self.inCircleLabel.text = nil
        self.inCircleWithLabel.text = nil
        
        self.userNameLabel.text = userName
        self.inCircleLabel.text = "in " + inCircleName
        if let circleWith = inCircleWith {
            self.inCircleWithLabel.text = "w/t " + circleWith
        } else {
            self.inCircleWithLabel.text = "by themselves."
        }
    
        let imageRef = self.storageRef.reference(withPath: userImageString)
        let placeHolder = UIImage(color: Constant.myGrayColor)
        self.userImageView.sd_setImage(with: imageRef, placeholderImage: placeHolder)
        
        if inCircleWithCount >= 7 {
            self.accessoryView = self.fullLabel
        } else {
            self.accessoryType = .disclosureIndicator
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func animateFullLabel() {
        
        UIView.transition(with: self.fullLabel, duration: 0.01, options: .transitionCrossDissolve, animations: {
            self.fullLabel.textColor = UIColor.red
        }, completion: { (x) in
            UIView.transition(with: self.fullLabel, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.fullLabel.textColor = UIColor.lightGray
            }, completion: nil)
        })
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userImageView.image = nil
        self.userNameLabel.text = nil
        self.inCircleLabel.text = nil
        self.inCircleWithLabel.text = nil
        self.detailTextLabel?.text = nil
        self.accessoryType = .none
        self.accessoryView = nil
    }

}
