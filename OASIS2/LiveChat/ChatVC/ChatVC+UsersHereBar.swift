//
//  ChatVC+UsersHereBar.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/20/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit
import FirebaseAuth

extension ChatVC : UsersHereBarViewDelegate {
    
    
    func setupUsersHereBar() {
        
        let size = CGSize(width: self.view.bounds.width, height: 47)
        let origin = CGPoint(x: 0, y: 44)
        let frame = CGRect(origin: origin, size: size)
        
        self.usersHereBar.frame = frame
        
        let border = CALayer()
        border.backgroundColor = Constant.myGrayColor.cgColor
        border.frame = CGRect(x: 0, y: usersHereBar.frame.size.height - 0.6, width: usersHereBar.frame.size.width, height: 0.6)
        self.usersHereBar.layer.addSublayer(border)
        
        self.view.addSubview(usersHereBar)
        
        self.usersHereBar.circleID = circleID
        self.usersHereBar.barDelegate = self
        
    }
    
    func startUsersHereBar() {
        
        self.usersHereBar.startFetcher()
    }
    
    
    
    
    
    
    
    // MARK:- Delegate Methods
    
    
    func newUserJoined(userHere: UserHere) {
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        guard myUID != userHere.userID else { return }
        
        if circleID == myUID {
            self.unseenUsersHere.append(userHere)
            self.changeBadgeValue(override: false, by: +1)
        }
        
    }
    
    func oldUserLeft(userID: String) {
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        guard myUID != userID else { return }

        if circleID == myUID && self.unseenUsersHere.contains(where: {$0.userID == userID}) {
            //don't -1 to badge if user already seen.
            self.unseenUsersHere.removeAll(where: {$0.userID == userID})
            self.changeBadgeValue(override: false, by: -1)
        }
    }
    
    
    func numUsersHereUpdated(numLive: Int) {
        self.updateUsersLive(usersLive: numLive)
    }
    
    
    func userProfileRequested(userID: String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        var profileView : UserProfileView!
        if myUID == userID {
            profileView = UserProfileView(userID: userID, buttonEnabled: false)
        } else {
            profileView = UserProfileView(userID: userID, buttonEnabled: true)
        }
        
        let attributes = Constant.bottomPopUpAttributes
        
        DispatchQueue.main.async {
            
            self.inputBarView.inputTextView.resignFirstResponder()
            SwiftEntryKit.display(entry: profileView, using: attributes)
        }
    }
    
    
    
    @IBAction func cellUserImageTapped(_ sender:AnyObject){
        
        guard let sndr = sender as? MyTapGestureRecognizer else { return }
        
        guard let userID = sndr.stringTag else { return }
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        var profileView : UserProfileView!
        if myUID == userID {
            profileView = UserProfileView(userID: userID, buttonEnabled: false)
        } else {
            profileView = UserProfileView(userID: userID, buttonEnabled: true)
        }
        
        let attributes = Constant.bottomPopUpAttributes
        
        DispatchQueue.main.async {
            
            self.inputBarView.inputTextView.resignFirstResponder()
            SwiftEntryKit.display(entry: profileView, using: attributes)
        }
        
    }
    
    
}
