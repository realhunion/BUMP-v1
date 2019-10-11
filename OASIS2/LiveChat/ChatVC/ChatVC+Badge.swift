//
//  ChatVC+Delegate.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/2/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit


extension ChatVC {
    
    
    func changeBadgeValue(override : Bool, by value : Int = 0) {
        
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.oasis?.homeTabBarVC.updateChatBadgeValue(isOnline: true, override: override, by: value)
        
    }
    
    
    
}
