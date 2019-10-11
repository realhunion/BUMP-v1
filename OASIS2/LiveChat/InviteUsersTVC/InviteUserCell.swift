//
//  InviteUserTableViewCell.swift
//  OASIS2
//
//  Created by Hunain Ali on 7/21/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import UIKit

class InviteUserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    
    func setUnInvited() {
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = UIColor.white
        self.textLabel?.textColor = UIColor.black
        //self.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 17.0)!
//        self.textLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        //self.textLabel?.font = UIFont(name: "HelveticaNeue", size: 19.0)!
        
//        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        self.detailTextLabel?.textColor = UIColor.gray
        
        let tFont = self.textLabel?.font
        self.textLabel?.font = UIFont.systemFont(ofSize: tFont?.pointSize ?? 17.0, weight: .regular)
        
        let dFont = self.detailTextLabel?.font
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: dFont?.pointSize ?? 13.0, weight: .regular)
    }
    
    func setInvited() {
        self.tintColor = UIColor.white
        self.accessoryType = .checkmark
        self.backgroundColor = Constant.oBlueDark
        self.textLabel?.textColor = UIColor.white
//        self.textLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        
        let tFont = self.textLabel?.font
        self.textLabel?.font = UIFont.systemFont(ofSize: tFont?.pointSize ?? 17.0, weight: .medium)
        
        let dFont = self.detailTextLabel?.font
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: dFont?.pointSize ?? 13.0, weight: .medium)
        
        self.detailTextLabel?.textColor = UIColor.white
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setUnInvited()
    }

}
