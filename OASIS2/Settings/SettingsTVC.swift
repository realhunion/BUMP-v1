//
//  SettingsTVC.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/29/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftEntryKit

struct SettingsCell {
    var title : String
    var image : UIImage?
    var disclosureIndicator : Bool
}

class SettingsTVC: UITableViewController {
    
    var followingTVC : FollowingTVC?
    var followersTVC : FollowersTVC?
    
    let settingCellArray : [[SettingsCell]] = [
        [SettingsCell(title: "My Profile", image: nil, disclosureIndicator: true),
         SettingsCell(title: "Following", image: nil, disclosureIndicator: true),
         SettingsCell(title: "Followers", image: nil, disclosureIndicator: true)],
        [SettingsCell(title: "AutoFollow", image: nil, disclosureIndicator: true)],
        [SettingsCell(title: "Credits", image: nil, disclosureIndicator: true),
         SettingsCell(title: "Privacy & Terms Of Use", image: nil, disclosureIndicator: true),
         SettingsCell(title: "Contact Info", image: nil, disclosureIndicator: true)],
        [SettingsCell(title: "Log Out", image: UIImage(named: "logout")!, disclosureIndicator: false)]
    ]
    

    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("noti SETTINGS TVC is deinit")
    }
    
    
    func setupCellControllers() {
        self.followingTVC = FollowingTVC()
        self.followingTVC?.monitorUsersList()
        self.followersTVC = FollowersTVC()
        self.followersTVC?.monitorUsersList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        
        self.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupCellControllers()
    }
    
    
    func shutDown() {
        self.followingTVC?.shutDown()
        self.followersTVC?.shutDown()
    }
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingCellArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingCellArray[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)

        cell.imageView?.image = nil
        cell.textLabel?.text = nil
        cell.accessoryType = .none
        
        cell.textLabel?.text = self.settingCellArray[indexPath.section][indexPath.row].title
        
        if let image = self.settingCellArray[indexPath.section][indexPath.row].image {
            cell.imageView?.image = image
        }

        if self.settingCellArray[indexPath.section][indexPath.row].disclosureIndicator {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let settingsCell = self.settingCellArray[indexPath.section][indexPath.row]
        
        switch settingsCell.title {
            
        case "My Profile":
            
            let nvc = UINavigationController(rootViewController: self)
            nvc.view.layer.cornerRadius = 18.0
            nvc.view.layer.masksToBounds = true
            var attributes = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)
            attributes.precedence = .enqueue(priority: .low)
            SwiftEntryKit.display(entry: nvc, using: attributes)
            
            
            let vc = UserProfileView(userID: myUID)
            let atr = Constant.bottomPopUpAttributes
            DispatchQueue.main.async {
                SwiftEntryKit.display(entry: vc, using: atr)
            }
            
        case "Following":
            let vc = self.followingTVC ?? FollowingTVC()
            navigationController?.pushViewController(vc, animated: true)
            
        case "Followers":
            let vc = self.followersTVC ?? FollowersTVC()
            navigationController?.pushViewController(vc, animated: true)
            
        case "AutoFollow":
            
            let nvc = UINavigationController(rootViewController: self)
            nvc.view.layer.cornerRadius = 18.0
            nvc.view.layer.masksToBounds = true
            var attributes = Constant.fixedPopUpAttributes(heightWidthRatio: 0.9)
            attributes.precedence = .enqueue(priority: .low)
            SwiftEntryKit.display(entry: nvc, using: attributes)

            let autoFollowView = AutoFollowView()
            let atr = Constant.centerPopUpAttributes
            DispatchQueue.main.async {
                SwiftEntryKit.display(entry: autoFollowView, using: atr)
            }
            
            
        case "Credits":
            //FIX: credits
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white
            vc.edgesForExtendedLayout = []
            
            let infoView = InfoTextView(text: Constant.credits)
            vc.view.addSubview(infoView)
            infoView.frame = self.view.frame
            vc.title = "Credits"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Contact Info":
            //FIX: credits
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white
            vc.edgesForExtendedLayout = []
            
            let infoView = InfoTextView(text: Constant.contactInfo)
            vc.view.addSubview(infoView)
            infoView.frame = self.view.frame
            vc.title = "Contact Info"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Privacy & Terms Of Use":
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.white
            vc.edgesForExtendedLayout = []
            
            let infoView = InfoTextView(text: Constant.privacyInfo)
            vc.view.addSubview(infoView)
            infoView.frame = self.view.frame
            vc.title = "Privacy"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "Log Out":
            MyFavoriteFriends.shared.saveToFirebase { (allGood) in
                guard allGood else { return }
                let defaults = UserDefaults.standard
                defaults.dictionaryRepresentation().keys.forEach { defaults.removeObject(forKey: $0) }
                (UIApplication.shared.delegate as! AppDelegate).oasis?.shutDown()
                if let x = try? Auth.auth().signOut() {
                    (UIApplication.shared.delegate as! AppDelegate).setRootVC()
                } else {
                    self.presentAlertView(title: "Sign out failed.", subtitle: "")

                }
                
//                do {
//                    let defaults = UserDefaults.standard
//                    defaults.dictionaryRepresentation().keys.forEach { defaults.removeObject(forKey: $0) }
//                    (UIApplication.shared.delegate as! AppDelegate).oasis?.shutDown()
//                    try Auth.auth().signOut()
//
//                    (UIApplication.shared.delegate as! AppDelegate).setRootVC()
//                }
//            } catch let signOutError as NSError {
//                print ("Error signing out: %@", signOutError)
//                self.presentAlertView(title: "Sign out failed.", subtitle: "")
//            }
            
            
            
        }
            
            
        default:
            break
            // do none
        }
    }
    
    
    
    
    
    func presentAlertView(title : String, subtitle : String) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    

    
    
    
    
}
