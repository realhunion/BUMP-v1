//
//  NotificationTVC+Delegate.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/4/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit

extension NotificationTVC {
    
    
    
    func changeBadgeValue(by value : Int) {
        
        self.tabBarItem.badgeColor = Constant.vividRed

        self.tabBarItem.tag += value

        let count = self.tabBarItem.tag

        self.tabBarItem.badgeValue = String(count)
        
    }
    
    
    
    
    func resetBadgeValue() {
        
        self.tabBarItem.tag = 0
        
        self.tabBarItem.badgeValue = nil
        
    }
    
    
    
    
}
