//
//  MainTabBarVC.swift
//  OASIS2
//
//  Created by Honey on 5/22/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import Firebase
import SwiftEntryKit

enum Tabs: Int {
    case liveFriends = 0
    case liveChat = 1
    case notifications = 2
}

class HomeTabBarVC: UITabBarController, UITabBarControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    
    var circleManager : CircleManager = CircleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        self.delegate = self
        
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = Constant.oBlueDark
        self.tabBar.backgroundColor = .white
        self.tabBar.barTintColor = .white
    }
    
    func shutDown() {
        
        liveFriendsVC.shutDown()
        notificationVC.shutDown()
        circleManager.shutDown()
        
    }
    
    
    
    
    var liveFriendsVC = LiveFriendsTVC()
    var liveChatVC = UIViewController()
    var notificationVC = NotificationTVC()
    
    func setupTabBar() {
        
        liveFriendsVC.title = "Join a Friend"
        liveChatVC.title = "Home"
        notificationVC.title = "Notifications"
        
        let liveFriendsNC = UINavigationController(rootViewController: liveFriendsVC)
        let liveChatNC = UINavigationController(rootViewController: liveChatVC)
        let notificationNC = UINavigationController(rootViewController: notificationVC)

        
        let friendsImage =  UIImage(named: "friends")!.resizedImage(newSize: CGSize(width: 30, height: 30))
        let homeImage = UIImage(named: "home")!.resizedImage(newSize: CGSize(width: 30, height: 30))
        let bellsImage = UIImage(named: "bells")!.resizedImage(newSize: CGSize(width: 30, height: 30))
        
        let liveFriendsItem = UITabBarItem(title: "Friends", image: friendsImage, selectedImage: nil)
        let liveChatItem = UITabBarItem(title: liveChatVC.title, image: homeImage, selectedImage: nil)
        let bellsItem = UITabBarItem(title: notificationVC.title, image: bellsImage, selectedImage: nil)

        liveFriendsItem.tag = 0
        liveChatItem.tag = 0
        bellsItem.tag = 0
        
        
        liveFriendsVC.tabBarItem = liveFriendsItem
        liveChatVC.tabBarItem = liveChatItem
        notificationVC.tabBarItem = bellsItem
        
        liveFriendsVC.view.backgroundColor = UIColor.white
        liveChatVC.view.backgroundColor = UIColor.white
        notificationVC.view.backgroundColor = UIColor.white
        
        let tabBarControllers = [liveFriendsNC, liveChatNC, notificationNC]
        self.viewControllers = tabBarControllers
        self.selectedIndex = currentIndex
        
    }
    
    
    
    
    var currentIndex : Int = Tabs.liveFriends.rawValue
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        currentIndex = selectedIndex
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        if selectedIndex == Tabs.liveChat.rawValue {
            
            self.circleManager.enterHomeCircle()
            
        }
        
        if selectedIndex == Tabs.notifications.rawValue {
            
            let navVC = UINavigationController(rootViewController: self.notificationVC)
            navVC.view.layer.cornerRadius = 18.0
            navVC.view.layer.masksToBounds = true

            let attributes = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)

            DispatchQueue.main.async {

                SwiftEntryKit.display(entry: navVC, using: attributes)
            }
            
        }
        
        self.selectedIndex = currentIndex
        
    }
    
    
    
    
    
    
    
    
    
    
    // 0 means reset. any other add.
    func updateChatBadgeValue(isOnline : Bool = true, override : Bool = false, by value : Int = 0) {
        
        guard isOnline else {
            
            self.liveChatVC.tabBarItem.tag = 0
            self.liveChatVC.tabBarItem.badgeColor = UIColor.orange
            self.liveChatVC.tabBarItem.badgeValue = ""
            return
        }
        
        if override {
            
            self.liveChatVC.tabBarItem.tag = value
            self.liveChatVC.tabBarItem.badgeColor = Constant.chillGreen
            self.liveChatVC.tabBarItem.badgeValue = ""
            
        } else {
            
            self.liveChatVC.tabBarItem.tag += value
            let count = self.liveChatVC.tabBarItem.tag
            
            if count > 0 {
                self.liveChatVC.tabBarItem.badgeColor = Constant.vividRed
                self.liveChatVC.tabBarItem.badgeValue = "\(count) New"
            } else {
                self.liveChatVC.tabBarItem.badgeColor = Constant.chillGreen
                self.liveChatVC.tabBarItem.badgeValue = ""
            }
            
        }
    }
    
    

}
