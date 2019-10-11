//
//  CircleUsersLiveBarView.swift
//  OASIS2
//
//  Created by Honey on 6/8/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit


protocol UsersHereBarViewDelegate:class {
    
    func newUserJoined(userHere : UserHere)
    func oldUserLeft(userID : String)
    
    func numUsersHereUpdated(numLive : Int)
    
    func userProfileRequested(userID : String)
}


class UsersHereBarView : UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let leftRightSpacing : CGFloat = 24.0
    let middleSpacing : CGFloat = 25.0
    let bottomSpacing : CGFloat = 8.0
    
    weak var barDelegate : UsersHereBarViewDelegate?
    var circleInfoFetcher : CircleInfoFetcher?
    
    var circleID : String!
    
    var userHereArray : [UserHere] = []
    

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        if let l = layout as? UICollectionViewFlowLayout {
            l.scrollDirection = .horizontal
        }
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Users Here Bar DE INIT")
    }
    
    func startFetcher() {
        
        guard self.circleInfoFetcher == nil else { return }
        
        self.circleInfoFetcher = CircleInfoFetcher(circleID: circleID)
        self.circleInfoFetcher?.delegate = self
        self.circleInfoFetcher?.monitorUsersAdded()
        self.circleInfoFetcher?.monitorUsersRemoved()
    }
    
    func shutDown() {
        self.circleInfoFetcher?.shutDown()
        self.circleInfoFetcher = nil
        self.delegate = nil
        self.barDelegate = nil
    }
    
    func setupCollectionView() {
        
        self.isPagingEnabled = true
        self.allowsSelection = true
        self.allowsMultipleSelection = false
        
        self.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        
        self.register(UserHereCell.self, forCellWithReuseIdentifier: "userHereCell")
        self.dataSource = self
        self.delegate = self
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userHereArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = self.dequeueReusableCell(withReuseIdentifier: "userHereCell", for: indexPath) as! UserHereCell
        
        let userID = userHereArray[indexPath.row].userID
        
        myCell.updateUserImage(userID: userID)
        
        return myCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.setContentOffset(self.contentOffset, animated: false)
        
        let userID = userHereArray[indexPath.row].userID
        self.barDelegate?.userProfileRequested(userID: userID)
    }
    
    
}



extension UsersHereBarView : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.bounds.height - (self.bottomSpacing+0),
                      height: self.bounds.height - (self.bottomSpacing+0))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.middleSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let numItems = userHereArray.count
        
        let itemsWidth = CGFloat(numItems) * (self.bounds.height - self.bottomSpacing)
        let itemsSpacingWidth = CGFloat(numItems-1) * self.middleSpacing
        let total = itemsWidth + itemsSpacingWidth
        
        var oneSideWidth = (self.frame.width - total) / 2
        
        if oneSideWidth < self.leftRightSpacing {
            oneSideWidth = leftRightSpacing
        }
        
        return UIEdgeInsets(top: 0, left: oneSideWidth, bottom: self.bottomSpacing, right: oneSideWidth)
        
    }
    
    
    
    

}
