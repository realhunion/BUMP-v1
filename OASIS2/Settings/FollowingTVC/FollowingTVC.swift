//
//  FollowingTVC.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/29/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import Firebase
import SwiftEntryKit

class FollowingTVC: UITableViewController {
    
    var db = Firestore.firestore()
    
    var listener : ListenerRegistration?
    var userProfileFetcherArray : [UserProfileFetcher] = []
    
    var userProfileArray : [UserProfile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "followingCell")
        
        self.title = "Following"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    deinit {
        print("noti followingTVC de init")
    }
    
    func shutDown() {
        if let listenr = listener {
            listenr.remove()
        }
        self.userProfileFetcherArray.forEach { (fetcher) in
            fetcher.shutDown()
        }
        self.userProfileFetcherArray = []
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfileArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "followingCell")

        cell.textLabel?.text = userProfileArray[indexPath.row].userName
        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.text = "@" + userProfileArray[indexPath.row].userHandle
        cell.detailTextLabel?.textColor = UIColor.gray
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
 
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userID = self.userProfileArray[indexPath.row].userID
        
        let uProfileViewer = UserProfileView(userID: userID)
        SwiftEntryKit.display(entry: uProfileViewer, using: Constant.bottomPopUpAttributes)
        
        if let selfNavVC = self.navigationController {
            var attributes = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)
            attributes.precedence = .enqueue(priority: .normal)
            SwiftEntryKit.display(entry: selfNavVC, using: attributes)
        }
        
    }
    
    
    


}
