//
//  CircleInFetcher.swift
//  OASIS2
//
//  Created by Honey on 7/2/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase


struct UserHere {
    var userID : String
    var userName : String
}


protocol CircleInfoFetcherDelegate: class {
    func userHereAdded(circleID : String, userHere: UserHere)
    func userHereRemoved(circleID : String, userID: String)
    
    func usersHereUpdated(circleID: String, userHereArray: [UserHere])
}


class CircleInfoFetcher {
    
    
    var ref = Database.database().reference()
    
    weak var delegate : CircleInfoFetcherDelegate?
    
    var addRefHandle : DatabaseHandle?
    var removeRefHandle : DatabaseHandle?
    var updateRefHandle : DatabaseHandle?
    
    
    var circleID : String
    init(circleID : String) {
        self.circleID = circleID
    }
    
    func shutDown() {
        self.delegate = nil
        self.removeListener()
    }
    
    
    
    func monitorUsersHere() {
        
        let ref1 = ref.child("Circle-Users-Here").child(circleID)
        
        self.updateRefHandle = ref1.observe(.value, with: { (snap) in
            guard let data = snap.value as? [String:Any] else {
                self.delegate?.usersHereUpdated(circleID: self.circleID, userHereArray: [])
                return
            }
            
            var uHereArray : [UserHere] = []
            
            data.forEach({ (userID, userName) in
                if let userName = userName as? String {
                    let userHere = UserHere(userID: userID, userName: userName)
                    uHereArray.append(userHere)
                }
            })
            
            self.delegate?.usersHereUpdated(circleID: self.circleID, userHereArray: uHereArray)
        })
    
    }
    
    func monitorUsersRemoved() {
        
        let ref1 = ref.child("Circle-Users-Here").child(circleID)
        
        self.removeRefHandle = ref1.observe(.childRemoved, with: { (snapshot) in
            
            let userID = snapshot.key
            self.delegate?.userHereRemoved(circleID: self.circleID, userID: userID)
            
            
        })
    }
    
    func monitorUsersAdded() {
        
        print("lil uzi 0 \(self.circleID)")
        
        let ref1 = ref.child("Circle-Users-Here").child(circleID)
        
        self.addRefHandle = ref1.observe(.childAdded, with: { (snapshot) in
            
            print("lil uzi \(self.circleID)")
            
            guard let userName = snapshot.value as? String else { return }
            
            let userID = snapshot.key
            let userHere = UserHere(userID: userID, userName: userName)
            
            self.delegate?.userHereAdded(circleID: self.circleID, userHere: userHere)
            
        })
        
    }
    
    func removeListener() {
        
        let ref1 = ref.child("Circle-Users-Here").child(circleID)
        
        if let addHandl = addRefHandle {
            ref1.removeObserver(withHandle: addHandl)
        }
        if let removeHandl = removeRefHandle {
            ref1.removeObserver(withHandle: removeHandl)
        }
        if let updateHandl = updateRefHandle {
            ref1.removeObserver(withHandle: updateHandl)
        }
        
    }
    
    
    
    
    func getUsersHere() {
        
        print("mono 666666____")
        
        let ref1 = ref.child("Circle-Users-Here").child(circleID)
        ref1.observeSingleEvent(of: .value) { (snap) in
            
            guard let data = snap.value as? [String:Any] else {
                self.delegate?.usersHereUpdated(circleID: self.circleID, userHereArray: [])
                return
            }
            
            var uHereArray : [UserHere] = []
            
            data.forEach({ (userID, userName) in
                if let userName = userName as? String {
                    let userHere = UserHere(userID: userID, userName: userName)
                    uHereArray.append(userHere)
                }
            })
            
            print("mono 666666")
            
            self.delegate?.usersHereUpdated(circleID: self.circleID, userHereArray: uHereArray)
            
        }
        
    }
    
    
}
