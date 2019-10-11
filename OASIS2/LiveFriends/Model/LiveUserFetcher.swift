//
//  LiveUserFetcher.swift
//  OASIS2
//
//  Created by Honey on 7/4/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase


protocol LiveUserFetcherDelegate : class {
    func liveUserUpdated(userID : String, liveUser : LiveUser)
}


class LiveUserFetcher {
    
    var db = Firestore.firestore()
    
    weak var delegate : LiveUserFetcherDelegate?
    
    var userStatusFetcher : UserStatusFetcher?
    var userProfileFetcher : UserProfileFetcher?
    var circleInfoFetcher : CircleInfoFetcher?
    
    var userStatus : UserStatus?
    var userProfile : UserProfile?
    var userHereArray : [UserHere]?
    
    var lastUpdate : LiveUser?
    //track last update.
    
    
    var inCircleWithMonitorEnabled : Bool
    var userID : String
    init(userID : String, inCircleWithMonitorEnabled : Bool) {
        self.userID = userID
        self.inCircleWithMonitorEnabled = inCircleWithMonitorEnabled
    }
    
    func shutDown() {
        print("mono 4 \(userID) \(self.inCircleWithMonitorEnabled)")
        self.userStatusFetcher?.shutDown()
        self.userProfileFetcher?.shutDown()
        self.circleInfoFetcher?.shutDown()
        self.delegate = nil
    }
    
    
    
    func startMonitor() {
        print("mono 5 \(userID) \(self.inCircleWithMonitorEnabled)")
        self.circleInfoFetcher = CircleInfoFetcher(circleID: "home")
        
        self.userStatusFetcher = UserStatusFetcher(userID: self.userID)
        self.userStatusFetcher?.delegate = self
        self.userStatusFetcher?.monitorUserStatus()
        
        self.userProfileFetcher = UserProfileFetcher(userID: self.userID)
        self.userProfileFetcher?.delegate = self
        self.userProfileFetcher?.monitorUserProfile()
    }
    
    
    func pauseInCircleWithMonitor() {
        
        print("trigger <-> 1 \(self.userID)")
        
        self.inCircleWithMonitorEnabled = false
        
        self.circleInfoFetcher?.shutDown()
        self.userHereArray = nil
    }
    
    func resumeInCircleWithMonitor() {
        
        print("mono resume \(userID)")
        
        guard self.inCircleWithMonitorEnabled == false else { return }
        self.inCircleWithMonitorEnabled = true
        
        guard let inCircleID = self.userStatus?.inCircleID else { return }
        
        self.circleInfoFetcher?.shutDown()
        
        self.circleInfoFetcher?.circleID = inCircleID
        self.circleInfoFetcher?.delegate = self
        self.circleInfoFetcher?.monitorUsersHere()
        
    }
    
    
    
    
    
    
    func triggerUpdate() {
        
        print("boom trigger \(self.userID) \(self.userStatus?.inCircleID)")
        
        guard let uProfile = self.userProfile else { return }
        guard let userStatus = self.userStatus else { return }
        guard let usersHereArray = self.userHereArray else { return }
        
        let liveUser = LiveUser(userID: self.userID,
                                userName: uProfile.userName,
                                userImage: uProfile.userImage,
                                inCircleID: userStatus.inCircleID,
                                inCircleName: userStatus.inCircleName,
                                userActive: userStatus.userActive)
        
        if let cInfoFetcher = self.circleInfoFetcher, userStatus.inCircleID == cInfoFetcher.circleID {
            // if userProfile's circleID matches, report back inCircleWith update.
            liveUser.userHereArray = usersHereArray
        }
        
        if let lastLiveUser = lastUpdate, self.checkIfLiveUserEqual(liveUser1: lastLiveUser, liveUser2: liveUser) {
            return
        }
        
        self.delegate?.liveUserUpdated(userID: self.userID, liveUser: liveUser)
        self.lastUpdate = liveUser
        print("boom trigger2.0 \(self.userID) \(self.userStatus?.inCircleID)")
    }
    
    func checkIfLiveUserEqual(liveUser1 u1 : LiveUser, liveUser2 u2 : LiveUser) -> Bool {
        
        let u1IDArray = u1.userHereArray.map({$0.userID})
        let u2IDArray = u2.userHereArray.map({$0.userID})
        
        if u1.userID != u2.userID {
            return false
        }
        else if u1.userActive != u2.userActive {
            return false
        }
        else if u1.userName != u2.userName {
            return false
        }
        else if u1.userImageString != u2.userImageString {
            return false
        }
        else if u1.inCircleID != u2.inCircleID {
            return false
        }
        else if u1.inCircleName != u2.inCircleName {
            return false
        }
        else if (u1IDArray.count != u2IDArray.count) || (u1IDArray.sorted() != u2IDArray.sorted()) {
            return false
        }
        else {
            return true
        }
    }
    
    
    
    
    func userStatusChangeResponder() {
        
        guard let userProfile = self.userProfile else { return }
        guard let userStatus = self.userStatus else { return }
        
        if !userStatus.userActive {
            
            self.triggerUpdate()
            
            self.inCircleWithMonitorEnabled = false
            
            self.circleInfoFetcher?.shutDown()
            self.userHereArray = nil
            self.lastUpdate = nil
            
            print("mono 1 \(userID)")
            
        }
        else if self.inCircleWithMonitorEnabled == true { //if inCircleWith on, circleInfoFetcher's circleID different, change it with new init.
            
            self.circleInfoFetcher?.shutDown()
            
            self.circleInfoFetcher?.circleID = userStatus.inCircleID
            self.circleInfoFetcher?.delegate = self
            self.circleInfoFetcher?.monitorUsersHere()
            
            print("mono 2 \(userID) \(userStatus.inCircleID)")
            
        }
        else { //if inCircleWith off, then just report back single inCircleWith udpate.
            
            if self.userHereArray == nil {
                self.circleInfoFetcher?.shutDown()
                
                self.circleInfoFetcher?.circleID = userStatus.inCircleID
                self.circleInfoFetcher?.delegate = self
                self.circleInfoFetcher?.getUsersHere()
                
                print("mono 3 \(userID)")
            }
        }
        
        
    }
    
    
    
}




extension LiveUserFetcher : UserStatusFetcherDelegate {
    
    func userStatusUpdated(userID: String, userStatus: UserStatus) {
        
        print("mono 000 \(userID) \(userStatus.inCircleName)")
        
        if self.userStatus?.inCircleID != userStatus.inCircleID {
            self.userHereArray = nil
        }
        
        self.userStatus = userStatus
        
        self.userStatusChangeResponder()
        
    }
    
}



extension LiveUserFetcher : UserProfileFetcherDelegate {
    
    func userProfileUpdated(userID: String, userProfile: UserProfile) {
        
        print("mono 001 \(userID)")
        
        self.userProfile = userProfile
        
        self.userStatusChangeResponder()
        
    }
    
}


extension LiveUserFetcher : CircleInfoFetcherDelegate {
    
    func userHereAdded(circleID: String, userHere: UserHere) {
        //
    }
    
    func userHereRemoved(circleID: String, userID: String) {
        //
    }
    
    func usersHereUpdated(circleID: String, userHereArray: [UserHere]) {
        
        guard self.userStatus?.inCircleID == circleID else { return }// if userProfile's circleID matches, report back inCircleWith update.
        
        self.userHereArray = userHereArray
        
        print("mono 6 \(userID) in \(self.userStatus?.inCircleID)")
        
        self.triggerUpdate()
        
    }
}
