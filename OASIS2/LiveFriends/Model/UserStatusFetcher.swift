//
//  UserActiveFetcher.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/11/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

struct UserStatus {
    var userID : String
    var userActive : Bool
    var inCircleID : String
    var inCircleName : String
}

protocol UserStatusFetcherDelegate :class {
    func userStatusUpdated(userID : String, userStatus : UserStatus)
}


class UserStatusFetcher {
    
    var ref = Database.database().reference()
    
    weak var delegate : UserStatusFetcherDelegate?
    
    var refHandle : DatabaseHandle?
    
    var userID : String
    init(userID : String) {
        self.userID = userID
    }
    
    
    
    
    
    func monitorUserStatus() {
        
        print("all Good cooper \(self.userID)")
        
        let ref1 = ref.child("User-Status").child(userID)
        self.refHandle = ref1.observe(.value, with: { (snapshot) in
            guard let postDict = snapshot.value as? [String : Any] else { return }
            
            if let userActive = postDict["userActive"] as? Bool,
                let inCircleID = postDict["inCircleID"] as? String,
                let inCircleName = postDict["inCircleName"] as? String
            {
                
                print("all Good gosteen user status \(self.userID) - \(inCircleID)")
                
                self.delegate?.userStatusUpdated(userID: self.userID, userStatus : UserStatus(userID: self.userID, userActive: userActive, inCircleID: inCircleID, inCircleName: inCircleName))
                
            }
            
        })
        
    }
    
    func removeListener() {
        let ref1 = ref.child("User-Status").child(userID)
        if let handl = refHandle {
            ref1.removeObserver(withHandle: handl)
        }
        ref1.removeAllObservers()
    }
    
    func shutDown() {
        self.delegate = nil
        self.removeListener()
    }
    
    
    
    
    
    
}
