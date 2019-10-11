//
//  LiveUser.swift
//  OASIS2
//
//  Created by Honey on 6/14/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import UIKit


class LiveUser {
    
    let favFriendsDict = MyFavoriteFriends.shared.getFavoriteFriends() ?? [:]

    var userHereArray : [UserHere] = []
    
    var userID : String
    var userName : String
    var userImageString : String
    var inCircleID : String
    var inCircleName : String
    
    var userActive : Bool

    init(userID : String, userName : String, userImage : String, inCircleID : String, inCircleName : String, userActive : Bool) {
        self.userID = userID
        self.userName = userName
        //self.userImage = userImage
        self.inCircleID = inCircleID
        self.inCircleName = inCircleName
        self.userActive = userActive
        
        self.userImageString = userImage
    }
    
    
    func generateInCircleWithString() -> String? {
        
        guard !self.userHereArray.isEmpty else { return nil }
        
        var uHereArray = self.userHereArray.filter({ $0.userID != self.userID })
        
        uHereArray.sort { (u1, u2) -> Bool in
            
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
        
        var userNameArray = uHereArray.map({ $0.userName })
        
        userNameArray = userNameArray.map({ String($0.split(separator: " ")[0]) })
        
        if userNameArray.isEmpty {
            return nil
        }
        else if userNameArray.count == 1 {
            return userNameArray.first!
        }
        else if userNameArray.count == 2 {
            return userNameArray[0] + " & " + userNameArray[1]
        }
        else if userNameArray.count == 3 {
            return userNameArray[0] + ", " + userNameArray[1] + ", " + userNameArray[2]
        }
        else {
            return userNameArray[0] + ", " + userNameArray[1] + ", " + userNameArray[2] + ", +" + String(userNameArray.count-3)
        }
    }
    
    
    
}
