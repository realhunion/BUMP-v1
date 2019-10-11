//
//  FavoriteFriends.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/10/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

class MyFavoriteFriends {
    
    static let shared: MyFavoriteFriends = { return MyFavoriteFriends() }()
    
    let db = Firestore.firestore()
    
    
    
    
    func saveToFirebase(completion:@escaping (_ success:Bool)->Void) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { completion(false); return }
        
        guard let favFriendsDict = self.getFavoriteFriends() else { completion(true); return }
        let data = ["favFriendsDict":favFriendsDict]
        
        db.collection("User-Base").document(myUID).setData(data, merge: true) { (err) in
            guard err == nil else { completion(false); return }
            completion(true)
        }
        
    }
    
    
    
    func getFavoriteFriends() -> [String:Int]? {

        guard let favFriendsDict = UserDefaults.standard.value(forKey: "favFriendsDict") as? [String:Int] else { return nil}

        print("gigigigi \(favFriendsDict)")

        return favFriendsDict

    }
    
    
    func changeFavoriteFriendPoints(userID : String, by points : Int) {
        
        var favFriendsDict = self.getFavoriteFriends() ?? [:]
        
        var totalPoints = points
        if let oldPoints = favFriendsDict[userID] {
            totalPoints += oldPoints
        }
        
        favFriendsDict[userID] = totalPoints
        
        UserDefaults.standard.setValue(favFriendsDict, forKey: "favFriendsDict")
        
    }
    

    
}
