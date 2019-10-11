//
//  LiveFriendsTVC+Fetcher.swift
//  OASIS2
//
//  Created by Honey on 6/14/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


enum TypeUpdate {
    case add
    case remove
    case update
}
struct CellUpdate {
    var userID : String
    var liveUser : LiveUser?
    var typeUpdate : TypeUpdate
}


extension LiveFriendsTVC : LiveFriendsFetcherDelegate {
    
    
    func startFetcher() {
        
        guard self.liveFriendsFetcher == nil else { return }
        
        self.favFriendsDict = MyFavoriteFriends.shared.getFavoriteFriends() ?? [:]
        
        self.setupOnlineHUD()
        
        print("all good start fetcher")
        self.liveFriendsFetcher = LiveFriendsFetcher()
        self.liveFriendsFetcher?.delegate = self
    }
    
    func stopFetcher() {
        
        self.favFriendsDict = [:]
        
        self.setupOfflineHUD()
        
        self.liveFriendsFetcher?.shutDown()
        self.liveFriendsFetcher = nil
        self.liveFriendArray = []
        self.tableView.reloadData()
    }
    
   
    
    
    
    
    func liveFriendRemoved(userID: String) {
        
        print("trigger <-> liveFriendRemovedd \(userID)")
        
        let cellUpdate = CellUpdate(userID: userID, liveUser: nil, typeUpdate: .remove)
        self.cellUpdateQueue[userID] = cellUpdate // automatically does nothing if nothing to remove. overrides previous updates.
        
        self.triggerCellUpdates()
        
    }
    
    func liveFriendUpdated(liveUser: LiveUser) {
        
        print("trigger <-> liveFriendUpdated \(liveUser.userName) - \(liveUser.generateInCircleWithString())")
        
        if let i = self.liveFriendArray.firstIndex(where: { $0.userID == liveUser.userID }) {
            self.liveFriendArray[i] = liveUser
            //this don't require no waiting. update data source.
            let cellUpdate = CellUpdate(userID: liveUser.userID, liveUser: liveUser, typeUpdate: .update)
            self.cellUpdateQueue[liveUser.userID] = cellUpdate
        }
        else {
            let cellUpdate = CellUpdate(userID: liveUser.userID, liveUser: liveUser, typeUpdate: .add)
            self.cellUpdateQueue[liveUser.userID] = cellUpdate
        }
        
        self.triggerCellUpdates()
        
    }
    
    
}


extension LiveFriendsTVC {
    
    func insertIntoLiveFriendArray(liveUsers : [LiveUser]) -> [Int] {
        
        for user in liveUsers {
            let i = indexOfInsertion(liveUser: user)
            self.liveFriendArray.insert(user, at: i)
        }
        
        var indexArray : [Int] = []
        for user in liveUsers {
            if let i = liveFriendArray.firstIndex(where: { $0.userID == user.userID }) {
                indexArray.append(i)
            }
        }
        return indexArray
    }
    
    func removeFromLiveFriendArray(userIDs : [String]) -> [Int] {
        
        var indexArray : [Int] = []
        for userID in userIDs {
            if let i = liveFriendArray.firstIndex(where: { $0.userID == userID }) {
                indexArray.append(i)
            }
        }
        
        self.liveFriendArray.removeAll(where: { userIDs.contains($0.userID)  })
        
        return indexArray
    }
    
    func updateIntoLiveFriendArray(liveUsers : [LiveUser]) -> [Int] {
        
        var indexArray : [Int] = []
        for user in liveUsers {
            if let i = liveFriendArray.firstIndex(where: { $0.userID == user.userID }) {
                self.liveFriendArray[i] = user
                indexArray.append(i)
            }
        }
        
        return indexArray
    }
    
    
    
    
    
    
    func indexOfInsertion(liveUser : LiveUser) -> Int {
        
        print("yogi \(self.favFriendsDict)")
        
        guard let myUID = Auth.auth().currentUser?.uid else { return 0 }
        
        if myUID == liveUser.userID {
            return 0
        }
        
        
        if let i = self.liveFriendArray.firstIndex(where: { (u2) -> Bool in
            
            let u1Points = self.favFriendsDict[liveUser.userID]
            let u2Points = self.favFriendsDict[u2.userID]
            
            if u2.userID == myUID {
                return false
            }
            else if u1Points != nil && u2Points != nil {
                if u2Points! == u1Points! {
                    //FIX: future switch to userName
                    return liveUser.userID.lowercased() <= u2.userID.lowercased()
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
                return liveUser.userID.lowercased() <= u2.userID.lowercased()
            }
        }) {
            return i
        } else {
            return self.liveFriendArray.count
        }
    }
    
    func indexOfRemoval(userID : String) -> Int? {
        if let i = self.liveFriendArray.firstIndex(where: { $0.userID == userID }) {
            return i
        } else {
            return nil
        }
    }
    
        
    
    

    
    func triggerCellUpdates() {
        
        guard self.isScrolling == false else { return }
        guard self.cellUpdateQueue.isEmpty == false else { return }
        
        guard let visibleIndexPathSet = self.tableView.indexPathsForVisibleRows else { return }
        
        self.tableView.backgroundView = nil
        //Remove the HUD
        
        let visibleRows = visibleIndexPathSet.map {$0.row}
        let min = visibleRows.min() ?? 0
        let max = (visibleRows.max() ?? 0) + 1 //account for last
        
        
        let cellUpdateArray = self.cellUpdateQueue.map { $0.value }
        self.cellUpdateQueue.removeAll()
        
        var topAdds : [CellUpdate] = []
        var bottomAdds : [CellUpdate] = []
        var middleAdds : [CellUpdate] = []
        
        var topRemovals : [CellUpdate] = []
        var bottomRemovals : [CellUpdate] = []
        var middleRemovals : [CellUpdate] = []
        
        var updates : [CellUpdate] = []
        
        for cellUpdate in cellUpdateArray {
            
            switch cellUpdate.typeUpdate {
            
            case .add:
                guard let liveUser = cellUpdate.liveUser else { break }
                
                let insertionIndex = indexOfInsertion(liveUser: liveUser)
                
                print("\(cellUpdate.userID) ---- \(insertionIndex) ii = min\(min) = max\(max)")
                
                if insertionIndex < min {
                    topAdds.append(cellUpdate)
                }
                else if max < insertionIndex {
                    bottomAdds.append(cellUpdate)
                }
                else {
                    middleAdds.append(cellUpdate)
                }
                
            case .remove:
                
                guard let removalIndex = indexOfRemoval(userID: cellUpdate.userID) else { break }
                
                if removalIndex < min {
                    topRemovals.append(cellUpdate)
                }
                else if max < removalIndex {
                    bottomRemovals.append(cellUpdate)
                }
                else {
                    middleRemovals.append(cellUpdate)
                }
                
            case .update:
                
                updates.append(cellUpdate)
                
            }
            
        }
        
        UIView.setAnimationsEnabled(false)
        self.tableView.performBatchUpdates({
            
            let updatesLiveUsers = updates.map { $0.liveUser! }
            let updatesIndexArray = self.updateIntoLiveFriendArray(liveUsers: updatesLiveUsers)
            let updatesIndexPathArray = updatesIndexArray.map { IndexPath(row: $0, section: 0) }
            self.tableView.reloadRows(at: updatesIndexPathArray, with: .none)
            
            
            topRemovals.forEach{ _ in self.tableView.contentOffset.y -= self.cellHeight }
            
            let removals = topRemovals + bottomRemovals
            let removalsUserIDs = removals.map { $0.userID }
            let removalsIndexArray = self.removeFromLiveFriendArray(userIDs: removalsUserIDs)
            let removalsIndexPathArray = removalsIndexArray.map { IndexPath(row: $0, section: 0) }
            self.tableView.deleteRows(at: removalsIndexPathArray, with: .none)
            
            
            topAdds.forEach{ _ in self.tableView.contentOffset.y += self.cellHeight }
            
            let adds = topAdds + bottomAdds
            let addsLiveUsers = adds.map { $0.liveUser! }
            let addsIndexArray = self.insertIntoLiveFriendArray(liveUsers: addsLiveUsers)
            let addsIndexPathArray = addsIndexArray.map { IndexPath(row: $0, section: 0) }
            self.tableView.insertRows(at: addsIndexPathArray, with: .none)
            
            
        }) { (isDone) in
            UIView.setAnimationsEnabled(true)
            self.tableView.performBatchUpdates({
                
                let removals = middleRemovals
                let removalsUserIDs = removals.map { $0.userID }
                let removalsIndexArray = self.removeFromLiveFriendArray(userIDs: removalsUserIDs)
                let removalsIndexPathArray = removalsIndexArray.map { IndexPath(row: $0, section: 0) }
                self.tableView.deleteRows(at: removalsIndexPathArray, with: .right)
                
                
                let adds = middleAdds
                let addsLiveUsers = adds.map { $0.liveUser! }
                let addsIndexArray = self.insertIntoLiveFriendArray(liveUsers: addsLiveUsers)
                let addsIndexPathArray = addsIndexArray.map { IndexPath(row: $0, section: 0) }
                self.tableView.insertRows(at: addsIndexPathArray, with: .left)

                
            }, completion: nil)}
        
    }
}
