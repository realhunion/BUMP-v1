//
//  NotificationsTVC+Fetcher.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/3/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

extension NotificationTVC : FollowerFetcherDelegate {
    
    func startFetcher() {
        
        guard self.followerFetcher == nil else { return }
        
        self.followerFetcher = FollowerFetcher(unSeenFollowersOnly: true)
        self.followerFetcher?.delegate = self
        self.followerFetcher?.startMonitor()
        
    }
    
    func newFollowerAdded(follower: Follower) {
        
        guard !self.notificationCellArray.contains(where: { $0.type == .follow && $0.itemID == follower.userProfile.userID }) else { return }
        
        guard !follower.seen else { return }
        
        self.tableView.performBatchUpdates({
            
            let title = "\(follower.userProfile.userName)"
            let description = "followed you."
            
            let notificationCell = NotificationCell(title: title, description: description, type: .follow, itemID: follower.userProfile.userID, itemName: follower.userProfile.userName)
            
            self.notificationCellArray.insert(notificationCell, at: 0)
            
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
            
        }, completion: nil)
        
        //let firebase know seen
        self.postSeenForFollowerID(followerID: follower.userProfile.userID)
        
        
        //let badge know
        self.changeBadgeValue(by: +1)
        
        
        
    }
    
    
    
    
    func postSeenForVisibleFollowerIDs() {
        
        self.notificationCellArray.forEach({ (cell) in
            self.postSeenForFollowerID(followerID: cell.itemID)
        })
        
    }
    func postSeenForFollowerID(followerID : String) {
        print("vice 1")
        if self.viewDidAppear == true {
            print("vice 2")
            self.followerFetcher?.postSeenForFollower(followerUserID: followerID)
        }
    }
    
    
}
