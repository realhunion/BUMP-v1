//
//  LiveFriendsTVC.swift
//  OASIS2
//
//  Created by Honey on 5/23/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import LayoutKit
import SPStorkController
import SwiftEntryKit


class LiveFriendsTVC: UITableViewController {
    
    let cellHeight : CGFloat = 98.0
    var favFriendsDict : [String:Int] = [:]
    
    var liveFriendArray : [LiveUser] = []
    var cellUpdateQueue : [String : CellUpdate] = [:] // UserID : CellUpdate
    
    var liveFriendsFetcher : LiveFriendsFetcher?
    
    var isScrolling : Bool = false {
        didSet {
            if self.isScrolling == false {
                self.triggerCellUpdates()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Constant.logTimestamp(label: "liveFriendsFetcher init")
        
        self.setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.isScrolling = false
        self.triggerCellUpdates()
    }
    
    deinit {
        print("LIVE FRIENDS TVC is de init")
    }
    
    
    func shutDown() {
        self.liveFriendsFetcher?.shutDown()
        self.liveFriendsFetcher?.delegate = nil
        self.tableView.delegate = nil
        
        self.liveFriendArray = []
        
        for v in self.tableView.subviews {
            v.removeFromSuperview()
        }
        self.tableView.backgroundView = nil
    }
    
    
    
    func setupOnlineHUD() {
        
        let progressHUD = ProgressHUD(text: "Going Online", color: Constant.mBlue)
        
        let tvBackgroundView = UIView()
        tvBackgroundView.frame = self.tableView.frame
        
        tvBackgroundView.addSubview(progressHUD)
        progressHUD.center = tvBackgroundView.center
        self.tableView.backgroundView = tvBackgroundView
        
        progressHUD.show()
        
    }
    
    func setupOfflineHUD() {
        
        let progressHUD = LabelHUD(text: "Offline")
        
        let tvBackgroundView = UIView()
        tvBackgroundView.frame = self.tableView.frame
        
        tvBackgroundView.addSubview(progressHUD)
        progressHUD.center = tvBackgroundView.center
        self.tableView.backgroundView = tvBackgroundView
        
        progressHUD.show()
        
    }
    
    
    func setupTableView() {
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: "AvenirNext-Bold", size: 30)!, .foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = [.font : UIFont(name: "AvenirNext-DemiBold", size: 17)!, .foregroundColor : UIColor.black]
        
        let bButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonTapped))
        self.navigationItem.setRightBarButton(bButtonItem, animated: true)
        
        tableView.indicatorStyle = .default
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        
        tableView.delegate = self
        
        tableView.register(LiveUserCell.self, forCellReuseIdentifier: "liveUserCell")
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let circleID = liveFriendArray[indexPath.row].inCircleID
        var circleName = liveFriendArray[indexPath.row].inCircleName
        let userID = liveFriendArray[indexPath.row].userID
        let circleWithCount = liveFriendArray[indexPath.row].userHereArray.count
        
        guard circleWithCount < 7 else {
            let cell = tableView.cellForRow(at: indexPath) as? LiveUserCell
            cell?.animateFullLabel()
            return
        }
        
        MyFavoriteFriends.shared.changeFavoriteFriendPoints(userID: userID, by: +1)
        
        if circleID == userID {
            let userName = liveFriendArray[indexPath.row].userName
            circleName = userName.split(separator: " ")[0] + "'s Circle"
        } // if person in his home circle, name circle. username's Circle.
        
        (UIApplication.shared.delegate as! AppDelegate).oasis?.homeTabBarVC.circleManager.enterCircle(circleID: circleID, circleName: circleName)
        
    }
    
    
    
    @objc func addButtonTapped() {
        
        let userLookupView = UserLookupView()
        var atr = Constant.centerPopUpAttributes
        
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: nil)
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
        atr.positionConstraints.keyboardRelation = keyboardRelation
        
        DispatchQueue.main.async {
            SwiftEntryKit.display(entry: userLookupView, using: atr)
            userLookupView.textField.becomeFirstResponder()
        }
        
        
    }
    
    
}
