//
//  NotificationTVC.swift
//  OASIS2
//
//  Created by Hunain Ali on 8/1/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import SwiftEntryKit

struct NotificationCell {
    var title : String
    var description : String
    var type : NotificationCellType
    var itemID : String //could be userID or circleID, based on type.
    var itemName : String //could be userName or circleName, based on type.
}
enum NotificationCellType {
    case invite, follow
}

class NotificationTVC: UITableViewController {
    
    var followerFetcher : FollowerFetcher?
    var settingsVC : SettingsTVC?
    
    var notificationCellArray : [NotificationCell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.settingsVC = SettingsTVC(style: .grouped)
        self.startFetcher()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "notificationsCell")
    }
    
    deinit {
        print("notification TVC is de init")
    }
    
    var viewDidAppear = false
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidAppear = true
        self.postSeenForVisibleFollowerIDs()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.resetBadgeValue()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.resetBadgeValue()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.viewDidAppear = false
        self.notificationCellArray = []
        self.tableView.reloadData()
    }
    
    
    func shutDown() {
        self.followerFetcher?.shutDown()
        self.settingsVC?.shutDown()
    }
    
    
    
    
    func setupView() {
//        let nItem = UINavigationItem()
        let bButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
//        nItem.setRightBarButton(bButtonItem, animated: true)
        self.navigationItem.setRightBarButton(bButtonItem, animated: true)
    }
    
    @objc func settingsTapped() {
        let settingsView = self.settingsVC ?? SettingsTVC(style: .grouped)
        let nvc = UINavigationController(rootViewController: settingsView)
        
        nvc.view.layer.cornerRadius = 18.0
        nvc.view.layer.masksToBounds = true
        
        let attributes = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)
        DispatchQueue.main.async {
            SwiftEntryKit.display(entry: nvc, using: attributes)
        }
    }
    
    
    
    
    
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notificationCellArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "notificationsCell")
        
        cell.selectionStyle = .none

        cell.textLabel?.textColor = UIColor.black
        cell.detailTextLabel?.textColor = UIColor.darkGray
        
        let notificationCell = self.notificationCellArray[indexPath.row]
        
        if notificationCell.type == .follow {
            
            cell.imageView?.image = UIImage(named: "Following")!
            cell.textLabel?.text = notificationCell.title
            cell.detailTextLabel?.text = notificationCell.description
            
            cell.accessoryType = .disclosureIndicator
        }
        
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notificationCell = self.notificationCellArray[indexPath.row]
        let itemID = notificationCell.itemID
        let itemName = notificationCell.itemName
        
        if notificationCell.type == .invite {
        }
        
        if notificationCell.type == .follow {
            
            let userProfileView = UserProfileView(userID: notificationCell.itemID)
            let atr = Constant.bottomPopUpAttributes
            
            var attributes = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)
            attributes.precedence = .enqueue(priority: .normal)
            let nvc = UINavigationController(rootViewController: self)
            nvc.view.layer.cornerRadius = 18.0
            nvc.view.layer.masksToBounds = true
            SwiftEntryKit.display(entry: nvc, using: attributes)
            
            DispatchQueue.main.async {
                SwiftEntryKit.display(entry: userProfileView, using: atr)
            }
            
        }
        
    }
        
        

}
