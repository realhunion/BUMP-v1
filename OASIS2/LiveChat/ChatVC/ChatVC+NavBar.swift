//
//  ChatVC+NavBar.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/20/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit

extension ChatVC {
    

    func setupNavBar() {
        
        self.navBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        self.navBar.barTintColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        self.navBar.isTranslucent = false
        self.navBar.setValue(true, forKey: "hidesShadow")
        
        let navItem = UINavigationItem(title: "")
        
        let tlabel = UILabel(frame: CGRect.zero)
        tlabel.text = self.circleName
        tlabel.textColor = UIColor.black
        tlabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center
        navItem.titleView = tlabel
        
        
        let numUsersLiveLabelItem = UIBarButtonItem(customView: numUsersLiveLabel)
        navItem.setRightBarButton(numUsersLiveLabelItem, animated: true)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        backButton.widthAnchor.constraint(equalToConstant: backButton.frame.size.width).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: backButton.frame.size.height).isActive = true
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navItem.setLeftBarButton(backButtonItem, animated: true)
        
        self.navBar.setItems([navItem], animated: true)
        
        self.view.addSubview(navBar)
    }
    
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func updateUsersLive(usersLive : Int) {
        
        print("bonbon___ \(usersLive)")
        
        let text = String(usersLive) + " here"
        self.numUsersLiveLabel.text = text
        self.numUsersLiveLabel.isHidden = false
        
//        self.numUsersLiveLabel.setTitle(text, for: .normal)
//        self.numUsersLiveLabel.titleLabel?.text = text
        
    }
    
    
}
