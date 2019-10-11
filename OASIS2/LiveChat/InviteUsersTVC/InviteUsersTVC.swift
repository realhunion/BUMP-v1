//
//  InviteTableVC.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/21/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import Firebase

class InviteUsersTVC: UITableViewController {
    
    let favFriendsDict = MyFavoriteFriends.shared.getFavoriteFriends() ?? [:]
    var sortByStar : Bool = true
    
    var db = Firestore.firestore()
    
    var circleID : String!
    
    var invitableUserArray : [InvitableUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSortButton()
        
        self.tableView.register(InviteUserTableViewCell.self, forCellReuseIdentifier: "inviteUserCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return invitableUserArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = InviteUserTableViewCell(style: .subtitle, reuseIdentifier: "inviteUserCell")
        
        cell.prepareForReuse()
        cell.selectionStyle = .none
        
        let invitableUser = self.invitableUserArray[indexPath.row]
        
        cell.textLabel?.text = invitableUser.userName
        cell.detailTextLabel?.text = "@" + invitableUser.userHandle
        
        if invitableUser.inviteSent == true {
            cell.setInvited()
        } else {
            cell.setUnInvited()
        }
 
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.invitableUserArray[indexPath.row].inviteSent = true
        self.tableView.reloadRows(at: [indexPath], with: .none)
        
        guard let uProfileDict = UserDefaults.standard.value(forKey: "userProfileDict") as? [String:Any], let userName = uProfileDict["userName"] as? String else { return }
        
        
        let invitableUserID = self.invitableUserArray[indexPath.row].userID
        
        let firstName = userName.split(separator: " ")[0]
        let circleName = String(firstName) + "'s Circle"
        
        
        let x = UserInviter(circleID: self.circleID, circleName: circleName)
        x.sendInviteToUser(userID: invitableUserID)
        
    }
    
    
    
}
