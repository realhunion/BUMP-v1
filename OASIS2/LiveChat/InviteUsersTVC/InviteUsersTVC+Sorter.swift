//
//  InviteUsersTVC+Sorter.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/10/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit

extension InviteUsersTVC {
    
    
    // tag 0 is alphabetically sort &&& tag 1 is star sort.
    func setSortButton() {
    
        guard let option = UserDefaults.standard.object(forKey: "inviteUsersTVCSortByStar") as? Bool else {
            
            let bButtonItem = UIBarButtonItem(title: "↓Ab", style: .plain, target: self, action: #selector(self.sortButtonToggeled))
            self.navigationItem.setRightBarButton(bButtonItem, animated: true)
            
            self.sortByStar = true
            
            UserDefaults.standard.setValue(true, forKey: "inviteUsersTVCSortByStar")
            
            return
            
        }
        
        if option == true {
            let bButtonItem = UIBarButtonItem(title: "↓Ab", style: .plain, target: self, action: #selector(self.sortButtonToggeled))
            self.navigationItem.setRightBarButton(bButtonItem, animated: true)
            self.sortByStar = true
        }
        else {
            let bButtonItem = UIBarButtonItem(title: "↓★", style: .plain, target: self, action: #selector(self.sortButtonToggeled))
            self.navigationItem.setRightBarButton(bButtonItem, animated: true)
            self.sortByStar = false
        }
        
    }
    
    @objc func sortButtonToggeled() {
        
        self.sortByStar = !self.sortByStar
        UserDefaults.standard.setValue(self.sortByStar, forKey: "inviteUsersTVCSortByStar")
        
        self.setSortButton()
        
        self.sortUserProfileArray()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
    
    
    func sortUserProfileArray() {
        
        if self.sortByStar {
            
            self.sortByStarFriends()
            
        } else {
            
            self.sortAlphabetically()
            
        }
        
    }
    
    
    
    func sortByStarFriends() {
        self.invitableUserArray.sort { (u1, u2) -> Bool in
            
            let u1Points = self.favFriendsDict[u1.userID]
            let u2Points = self.favFriendsDict[u2.userID]
            
            
            if u1Points != nil && u2Points != nil {
                if u2Points! == u1Points! {
                    return u1.userName.lowercased() <= u2.userName.lowercased()
                } else {
                    return u2Points! <= u1Points!
                }
            }
            else if u1Points != nil {
                return true
            }
            else if u2Points != nil {
                return false
            }
            else {
                return u1.userName.lowercased() <= u2.userName.lowercased()
            }
            
        }
    }
    
    func sortAlphabetically() {
        self.invitableUserArray.sort(by: {$0.userName.lowercased() <= $1.userName.lowercased()})
    }
    
    
    
}
