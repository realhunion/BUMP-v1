//
//  UserInviter.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/4/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

class UserInviter {
    
    var db = Firestore.firestore()
    
    var circleID : String
    var circleName : String
    init(circleID : String, circleName : String) {
        self.circleID = circleID
        self.circleName = circleName
        //FIX
    }
    
    
    
    
    func sendInviteToUser(userID : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        //fix Username
        let myUserName = "Hunion"
        
        let data : [String:Any] = ["circleID":circleID,
                                   "circleName":circleName,
                                   "fromUserID":myUID,
                                   "fromUserName":myUserName,
                                   "toUserID":userID
                                   ]
        
        db.collection("Send-Circle-Invite").document().setData(data)
        
        
    }
    
    
    
    
    
}
