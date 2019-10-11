//
//  UserProfileConfirmer.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/17/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import SwiftEntryKit
import Firebase


class UserDefaultsLoader {
    
    
    var storageRef = Storage.storage()
    var db = Firestore.firestore()
    
    var userID : String
    init(userID : String) {
        self.userID = userID
    }
    
    deinit {
        print("user defaulgts loader is de init")
    }
    
    
    
    
    func isAllLoaded() -> Bool {
        
        if !isUserProfileLoaded() {
            return false
        }
        else if !isFavFriendsLoaded() {
            return false
        }
        else {
            return true
        }
        
    }
    
    
    
    
    
    func isUserProfileLoaded() -> Bool {
        if self.fetchUserDefaultProfile() == nil {
            return false
        } else {
            return true
        }
    }
    
    func loadUserProfile() {
        guard self.fetchUserDefaultProfile() == nil else { return }
        fetchFirebaseUserProfileAndImage { (userImage, userName, userHandle, userDescription) in
            
            if let _ = userImage, let uName = userName, let uHandle = userHandle, let uDescription = userDescription {
                let uProfile = UserProfile(userID: self.userID, userName: uName, userHandle: uHandle, userImage: "User-Profile-Images/\(self.userID).jpg", userDescription: uDescription)
                self.saveUserDefaultProfile(userProfile: uProfile)
                
                (UIApplication.shared.delegate as! AppDelegate).oasis?.goOnline()
            }
            else {
                
                var atr = Constant.centerPopUpAttributes
                atr.entryInteraction = .absorbTouches
                atr.screenInteraction = .absorbTouches
                atr.scroll = .disabled
                let v = AutoFollowView()
                SwiftEntryKit.display(entry: v, using: atr)
                
                self.presentUserProfileEditView(userID: self.userID, userImage: userImage, userName: userName, userHandle: userHandle, userDescription: userDescription)
            }
        }
    }
    
    
    
    func fetchFirebaseUserProfileAndImage(completion:@escaping ( _ userImage:UIImage?, _ userName:String?, _ userHandle:String?, _ userDescription:String?)->Void) {
        
        var userImage : UIImage? = nil
        var userName : String? = nil
        var userHandle : String? = nil
        var userDescription : String? = nil
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        //FIX: what happens when theres an error
        db.collection("User-Profile").document(self.userID).getDocument { (snap, err) in
            guard let data = snap?.data() else { dispatchGroup.leave(); return }
            print("peenter 1")
            if let uName = data["userName"] as? String {
                userName = uName
            }
            
            if let uHandle = data["userHandle"] as? String {
                userHandle = uHandle
            }
            
            if let uDescription = data["userDescription"] as? String {
                userDescription = uDescription
            }
            
            dispatchGroup.leave()
            
        }
        
        dispatchGroup.enter()
        
        let filePath = "User-Profile-Images/\(self.userID).jpg"
        storageRef.reference(withPath: filePath).getData(maxSize: 1*1024*1024) { (data, err) in
            guard let data = data else { dispatchGroup.leave(); return }
            
            userImage = UIImage(data: data)
            dispatchGroup.leave()
            
        }
        
        
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            print("peenter 3")
                print("peenter 4")
                completion(userImage, userName, userHandle, userDescription)
            
            
        })
        
    }
    
    
    func presentUserProfileEditView(userID : String, userImage: UIImage?, userName : String?, userHandle : String?, userDescription : String?) {
        
        let v = UserProfileInitView(userID: userID, userImage: userImage, userName: userName, userHandle: userHandle, userDescription: userDescription)
        v.actionButton.setTitle("Save & Enter", for: .normal)
        v.actionButton.setTitleColor(.white, for: .normal)
        v.actionButton.backgroundColor = Constant.mBlue
        
        var atr = Constant.bottomPopUpAttributes
        atr.entryInteraction = .absorbTouches
        atr.screenInteraction = .absorbTouches
        atr.scroll = .disabled
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        atr.positionConstraints.keyboardRelation = keyboardRelation
        
        atr.precedence = .enqueue(priority: .normal)
        
        SwiftEntryKit.display(entry: v, using: atr)
        
    }
    
    
    
    
    
    
    // Save to User Defaults
    
    
    func saveUserDefaultProfile(userProfile : UserProfile) {
        
        let uProfileDict : [String:String] = ["userImage":userProfile.userImage,
                                              "userName":userProfile.userName,
                                              "userHandle":userProfile.userHandle,
                                              "userDescription":userProfile.userDescription]
        
        UserDefaults.standard.setValue(uProfileDict, forKey: "userProfileDict")
        
    }
    
    func fetchUserDefaultProfile() -> UserProfile? {
        
        guard let userProfileDict = UserDefaults.standard.value(forKey: "userProfileDict") as? [String:Any] else { return nil }
        
        if let uName = userProfileDict["userName"] as? String, let uHandle = userProfileDict["userHandle"] as? String, let uDescription = userProfileDict["userDescription"] as? String, let uImage = userProfileDict["userImage"] as? String {
            
            let uProfile = UserProfile(userID: self.userID, userName: uName, userHandle: uHandle, userImage: uImage, userDescription: uDescription)
            return uProfile
        } else {
            return nil
        }
        
    }
    
    
    
    
    
    
    
    
    
    
}
