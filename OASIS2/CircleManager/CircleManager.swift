//
//  CircleManager.swift
//  OASIS2
//
//  Created by Honey on 6/19/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import SPStorkController


class CircleManager {
    
    var db = Firestore.firestore()
    var ref = Database.database().reference()
    
    var chatVC : ChatVC?
    
    deinit {
        print("Circle Manager is de init")
    }
    
    func shutDown() {
        self.chatVC?.shutDown()
        self.chatVC = nil
    }
    
    
    //MARK: - Circle Manager Managers
    
    func resumeCircleManager() {
        
        self.loadHomeCircle()
    }
    
    
    func pauseCircleManager() {
        
        var oldCircleID : String? = nil
        if let oldChatVC = chatVC {
            oldCircleID = oldChatVC.circleID
        }
        
        self.updateStatusFirebase(oldCircleID: oldCircleID, newCircleID: nil, circleName: nil)
        
        self.chatVC?.shutDown()
        self.chatVC = nil
    }
    
    
    
    
    // MARK: Entering Circles
    
    func enterCircle(circleID : String, circleName : String) {
        
        if let _ = UIApplication.topViewController() as? ChatVC {
            // If by any glitch chatVC already is being presented.
            return
        }
        
        var oldCircleID : String? = nil
        if let oldChatVC = chatVC {
            oldCircleID = oldChatVC.circleID
        }
        
        
        self.setupChatVC(circleID: circleID, circleName: circleName)
        print("msgfetcher xxxx")
        self.presentChatVC {
            self.updateStatusFirebase(oldCircleID: oldCircleID, newCircleID: circleID, circleName: circleName)
        }
        
            
    }
    
    func loadHomeCircle() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        var oldCircleID : String? = nil
        if let oldChatVC = chatVC {
            oldCircleID = oldChatVC.circleID
        }
        
        
        var circleName = "Home"
        if let uProfileDict = UserDefaults.standard.value(forKey: "userProfileDict") as? [String:Any], let userName = uProfileDict["userName"] as? String {
            let firstName = userName.split(separator: " ")[0]
            circleName = String(firstName) + "'s Circle"
        }
        
        self.setupChatVC(circleID: myUID, circleName: circleName)
        self.updateStatusFirebase(oldCircleID: oldCircleID, newCircleID: myUID, circleName: "Home")
        
        print("msgfetcher 3")
        DispatchQueue.main.async {
            let _ = self.chatVC?.view
            self.chatVC?.startUsersHereBar()
            self.chatVC?.startMessageFetcher()
        }
        print("msgfetcher 3.5")
    }
    
    func enterHomeCircle() {
        
        self.presentChatVC { }
    }

    
    
    
    
    
    
    // MARK : Firebase update user-profile && enter circle users-here collection.
    
    func updateStatusFirebase(oldCircleID : String? = nil, newCircleID : String? = nil, circleName : String? = nil) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        guard let userProfileDict = UserDefaults.standard.value(forKey: "userProfileDict") as? [String:Any], let userName = userProfileDict["userName"] as? String else { return }
        
        
        if let newCircleID = newCircleID, let oldCircleID = oldCircleID {
            if oldCircleID == newCircleID {
                return
            }
        }
        

        
        if let oldCircleID = oldCircleID {
            
            let postRef = self.ref.child("Circle-Users-Here").child(oldCircleID).child(myUID)
            postRef.removeValue { (err, dbRef) in
                guard err != nil else { return }
                self.ref.cancelDisconnectOperations()
            }
        
        }
        
        if let newCircleID = newCircleID, let circleName = circleName {
            
            let ref2 = self.ref.child("User-Status").child(myUID)
            let data = ["userActive":true, "inCircleID":newCircleID, "inCircleName":circleName] as [String : Any]
            ref2.updateChildValues(data)
            print("dope")
            
            
            let postRef = self.ref.child("Circle-Users-Here").child(newCircleID).child(myUID)
            print("lil uzi ___")
            postRef.setValue(userName)
            postRef.onDisconnectRemoveValue()
            
        }
        
        

    }
    
    
    
    
    // MARK : present ChatVC
    
    
    func setupChatVC(circleID : String, circleName : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        //if same exact chatVC already exists, don't do anything
        if let oldChatVC = chatVC {
            if oldChatVC.circleID == circleID {
                return
            }
        }
        
        print("msgfetcher 0")
        self.chatVC?.shutDown()
        self.chatVC = nil
        print("msgfetcher 1")
        
        self.chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        self.chatVC?.circleID = circleID
        self.chatVC?.chatID = "testchat001"
        self.chatVC?.circleName = circleName
        
        self.chatVC?.tabBarItem.tag = 0
        print("msgfetcher 2")
    }
    
    func presentChatVC(completion:@escaping ()->Void) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        guard let vc = self.chatVC else { return }
        
        if let topController = UIApplication.topViewController() {
            
            let transitionDelegate = SPStorkTransitioningDelegate()
            transitionDelegate.showIndicator = false
            transitionDelegate.translateForDismiss = 100
            transitionDelegate.hapticMoments = []
            
            vc.transitioningDelegate = transitionDelegate
            vc.modalPresentationStyle = .custom
            vc.modalPresentationCapturesStatusBarAppearance = true
            
            topController.present(vc, animated: true) {
                completion()
                print("msgfetcher 4")
            }
        }
    
    }
    
    
}
