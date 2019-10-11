//
//  UserDefaultsLoader+AutoFollow.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/22/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UserDefaultsLoader {
    
    
    func isFavFriendsLoaded() -> Bool {
        if fetchUserDefaultFavFriends() == nil {
            return false
        } else {
            return true
        }
    }
    
    func loadFavFriends() {
        
        guard fetchUserDefaultFavFriends() == nil else { (UIApplication.shared.delegate as! AppDelegate).oasis?.goOnline(); return }
        
        self.fetchFirebaseFavFriends { (favFriendsDict) in
            if let dict = favFriendsDict {
                print("gigi \(dict)")
                self.saveUserDefaultFavFriends(favFriendsDict: dict)
                (UIApplication.shared.delegate as! AppDelegate).oasis?.goOnline()
            } else {
                self.loadFavFriends()
            }
        }
    }
    
    
    
    func fetchFirebaseFavFriends(completion:@escaping (_ favFriendsDict:[String:Int]?)->Void) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { completion(nil); return }
        
        db.collection("User-Base").document(myUID).getDocument { (snap, err) in
            guard let doc = snap else { completion(nil); return }
            
            if let data = doc.data(), let favFriendsDict = data["favFriendsDict"] as? [String:Int] {
                completion(favFriendsDict)
            } else {
                completion([:])
            }
            
        }
        
    }
    
    
    func saveFirebaseFavFriends(completion:@escaping (_ success:Bool)->Void) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { completion(false); return }
        
        guard let favFriendsDict = self.fetchUserDefaultFavFriends() else { completion(true); return }
        let data = ["favFriendsDict":favFriendsDict]
        
        db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
            guard err == nil else { completion(false); return }
            completion(true)
        }
        
    }
    
    
    
    
    
    func fetchUserDefaultFavFriends() -> [String:Int]? {
        
        guard let favFriendsDict = UserDefaults.standard.value(forKey: "favFriendsDict") as? [String:Int] else { return nil}
        
        return favFriendsDict
        
    }
    
    func saveUserDefaultFavFriends(favFriendsDict : [String:Int]) {
        UserDefaults.standard.setValue(favFriendsDict, forKey: "favFriendsDict")
    }
    
    
    
    
}
