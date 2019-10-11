//
//  UsersHereBarView+Fetcher.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/16/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UsersHereBarView : CircleInfoFetcherDelegate {
    
    
    
    func userHereAdded(circleID: String, userHere: UserHere) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        guard !self.userHereArray.contains(where: {$0.userID == userHere.userID}) else { return }
        
        DispatchQueue.main.async {
            
            self.performBatchUpdates({
                if let firstObject = self.userHereArray.first {
                    let firstUID = firstObject.userID
                    if firstUID == myUID {
                        self.userHereArray.insert(userHere, at: 1)
                        self.insertItems(at: [IndexPath(item: 1, section: 0)])
                    } else {
                        self.userHereArray.insert(userHere, at: 0)
                        self.insertItems(at: [IndexPath(item: 0, section: 0)])
                    }
                } else {
                    self.userHereArray.insert(userHere, at: 0)
                    self.insertItems(at: [IndexPath(item: 0, section: 0)])
                }
                
                
            })
        
            self.barDelegate?.newUserJoined(userHere : userHere)
            self.barDelegate?.numUsersHereUpdated(numLive: self.userHereArray.count)
        }
        
    }
    
    
    
    func userHereRemoved(circleID: String, userID: String) {
        
        print("lil uziiiii")
        
        guard self.userHereArray.contains(where: {$0.userID == userID}) else { return }
        
        self.performBatchUpdates({
            
            if let index = self.userHereArray.firstIndex(where: { $0.userID == userID }) {
                
                self.userHereArray.remove(at: index)
                
                self.deleteItems(at: [IndexPath(item: index, section: 0)])
                
            }
        })
        
        self.barDelegate?.oldUserLeft(userID : userID)
        self.barDelegate?.numUsersHereUpdated(numLive: self.userHereArray.count)
        
        
    }
    
    
    func usersHereUpdated(circleID: String, userHereArray: [UserHere]) {
        //
    }
    
    
    
}
