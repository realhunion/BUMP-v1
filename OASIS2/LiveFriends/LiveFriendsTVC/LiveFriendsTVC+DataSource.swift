//
//  LiveFriendsTVC+DataSource.swift
//  OASIS2
//
//  Created by Honey on 6/14/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import UIKit

extension LiveFriendsTVC {
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveFriendArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "liveUserCell", for: indexPath) as? LiveUserCell ?? LiveUserCell(style: .default, reuseIdentifier: "liveUserCell")
        
        let liveUser = liveFriendArray[indexPath.row]
        
        if !cell.initialized {
            cell.layoutCell()
        }
        
        cell.setupCell(userImageString: liveUser.userImageString, userName: liveUser.userName, inCircleName: liveUser.inCircleName, inCircleWith: liveUser.generateInCircleWithString(), inCircleWithCount: liveUser.userHereArray.count)
        
        
        self.prefetchRows()
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}




extension LiveFriendsTVC {
    
    // enable inCircleWith Monitor for rows near visibleRows only. Save listeners, save networking, effecient.
    func prefetchRows() {
        
        guard let visibleIndexPaths = self.tableView.indexPathsForVisibleRows else { return }
        
        let prefetchBatch = visibleIndexPaths.count
        //prefetch up & down equal to one screen length

        let visibleRows = visibleIndexPaths.map({ $0.row })
        
        let visibleUserIDArray = visibleRows.map({ self.liveFriendArray[$0].userID })
        
        var topUserIDArray : [String] = []
        if let min = visibleRows.min() {
            for row in min-prefetchBatch...min {
                if self.liveFriendArray.indices.contains(row) {
                    let userID = self.liveFriendArray[row].userID
                    topUserIDArray.append(userID)
                }
            }
        }
        
        var bottomUserIDArray : [String] = []
        if let max = visibleRows.max() {
            for row in max...max+prefetchBatch {
                if self.liveFriendArray.indices.contains(row) {
                    let userID = self.liveFriendArray[row].userID
                    bottomUserIDArray.append(userID)
                }
            }
        }
        
        let enableUserIDArray = topUserIDArray + visibleUserIDArray + bottomUserIDArray
        
        let disableUserIDArray = self.liveFriendArray.map({$0.userID}).filter({!enableUserIDArray.contains($0)})
        
        self.liveFriendsFetcher?.enableInCircleWith(for: enableUserIDArray)
        self.liveFriendsFetcher?.disableInCircleWith(for: disableUserIDArray)
        
        
        
    }
    
    
    
    
    
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrolling = true
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.isScrolling = false
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isScrolling = false
    }
    
    
    
}
