//
//  CircleManager+ChatVC.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/2/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import SPStorkController
import UIKit
import Firebase



extension CircleManager {
    
    func willDismissChatVC() {
        
        self.loadHomeCircle()
    }
    
    
    
//    func chatVCOfflineBadgeValue() {
//
//        let homeTabBarVC = (UIApplication.shared.delegate as! AppDelegate).oasis?.homeTabBarVC
//
//        print("joeeeeeee \(homeTabBarVC)")
//
//        homeTabBarVC?.liveChatVC.tabBarItem.tag = 0
//
//        homeTabBarVC?.liveChatVC.tabBarItem.badgeColor = Constant.dopeOrange
//        homeTabBarVC?.liveChatVC.tabBarItem.badgeValue = ""
//
//    }
//
//
//    func chatVCOnlineBadgeValue() {
//
//        let homeTabBarVC = (UIApplication.shared.delegate as! AppDelegate).oasis?.homeTabBarVC
//
//        homeTabBarVC?.liveChatVC.tabBarItem.tag = 0
//
//        homeTabBarVC?.liveChatVC.tabBarItem.badgeColor = Constant.chillGreen
//        homeTabBarVC?.liveChatVC.tabBarItem.badgeValue = ""
//
//    }
    
}
