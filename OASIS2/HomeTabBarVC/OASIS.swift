//
//  OASIS.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/13/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftEntryKit
import Reachability

class OASIS {
    
    deinit {
        print("OASIS is de init")
    }
    
    var homeTabBarVC : HomeTabBarVC
    var userDefaultsLoader : UserDefaultsLoader?
    var reachability : Reachability?
    
    var myUID : String
    init(myUID : String) {
        self.myUID = myUID
        
        self.homeTabBarVC = HomeTabBarVC()
        
        self.monitorInternetConnection()
        
        self.goOnline()
        
    }
    
    
    //MARK: - RootVC Manager
    
    func shutDown() {
        
        self.homeTabBarVC.shutDown()
        
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        self.reachability?.stopNotifier()
        
        self.connectedRef?.removeAllObservers()
        
        self.goOffline()
        
    }
    
    
    func goOnline() {
        
        Constant.logTimestamp(label: "onln1")
        
        if userDefaultsLoader == nil {
            self.userDefaultsLoader = UserDefaultsLoader(userID: myUID)
            self.userDefaultsLoader?.loadUserProfile()
            self.userDefaultsLoader?.loadFavFriends()
        }
        
        guard self.isForeground else { return }
        guard self.isInternetConnected else { return }
        
        self.goFirebaseOnOffline(isOnline: true)
        self.homeTabBarVC.liveFriendsVC.startFetcher()
        
        if userDefaultsLoader!.isUserProfileLoaded() {
            self.updateFirebaseUserStatus()
            self.homeTabBarVC.circleManager.resumeCircleManager()
            Constant.logTimestamp(label: "onln3")
        }
        
        
    }
    
    func goOffline() {
        
        //self.userDefaultsLoader.shutDown() //implement
        self.connectedRef = nil
        self.connectedRef?.removeAllObservers()
        
        self.userDefaultsLoader = nil
        
        self.homeTabBarVC.updateChatBadgeValue(isOnline: false)
        
        self.homeTabBarVC.liveFriendsVC.stopFetcher()
        self.homeTabBarVC.circleManager.pauseCircleManager()
        
        self.goFirebaseOnOffline(isOnline: false)
        
        SwiftEntryKit.dismiss(.all)
        self.homeTabBarVC.dismiss(animated: false, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: - Monitors
    
    var isForeground = true
    func appEnteredForeground() {
        self.isForeground = true
        self.goOnline()
    }
    func appWillEnterBackground() {
        self.isForeground = false
        self.goOffline()
    }
    
    
    var isInternetConnected = false
    func monitorInternetConnection() {
        self.reachability = Reachability()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try self.reachability?.startNotifier()
        } catch{
            print("could not start reachability notifier")
        }
    }
    @objc func reachabilityChanged(note: Notification) {
        
        guard let reachability = note.object as? Reachability else { return }
        
        switch reachability.connection {
        case .wifi:
            isInternetConnected = true
            self.goOnline()
        case .cellular:
            isInternetConnected = true
            self.goOnline()
        case .none:
            isInternetConnected = false
            self.goOffline()
        }
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: - Firebase Online Offline
    
    
    func goFirebaseOnOffline(isOnline : Bool) {
        
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        
        if isOnline {
            Database.database().goOnline()
        }
        else {
            Database.database().goOffline()
        }
    }
    
    
    var connectedRef : DatabaseReference?
    func updateFirebaseUserStatus() {
        
        guard connectedRef == nil else { return }
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let userStatusDatabaseRef = Database.database().reference(withPath: "User-Status/\(myUID)")
        
        // We'll create two constants which we will write to
        // the Realtime database when this device is offline
        // or online.
        let isOfflineForDatabase = [
            "userActive" : false,
            "lastActive" : ServerValue.timestamp(),
            "inCircleID" : myUID,
            "inCircleName" : "Home"
            ] as [String : Any]
        
        let isOnlineForDatabase = [
            "userActive" : true,
            "lastActive" : ServerValue.timestamp(),
            "inCircleID" : myUID,
            "inCircleName" : "Home"
            ] as [String : Any]
        
        
        self.connectedRef = Database.database().reference(withPath: ".info/connected")
        
        self.connectedRef?.observe(.value, with: { snapshot in
            guard let connected = snapshot.value as? Bool, connected else {
                return
            }

            userStatusDatabaseRef.onDisconnectSetValue(isOfflineForDatabase, withCompletionBlock: { (error, ref) in
                print("offset")
                userStatusDatabaseRef.setValue(isOnlineForDatabase)
            
            })
        })
    }
    
    
}
