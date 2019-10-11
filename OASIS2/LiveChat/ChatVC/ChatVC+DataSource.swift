//
//  ChatLogCollectionVC+DataSource.swift
//  OASIS2
//
//  Created by Honey on 5/24/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase
import UIKit

extension ChatVC {
    
    // MARK: UICollectionViewDataSource
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return msgArray.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let section = msgArray[section]
        return section.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let myUID = Auth.auth().currentUser?.uid else {
            let c = UICollectionViewCell()
            return c
        }
        
        let cellMeta = getMetaForCell(indexPath: indexPath)
        
        let msg = cellMeta.msg
        let imageEnabled = cellMeta.isUserImageEnabled
        let userNameEnabled = cellMeta.isUserNameEnabled
        
        
        if myUID != msg.userID {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: incomingTextMessageCellID,
                                                          for: indexPath) as? IncomingTextMessageCell ?? IncomingTextMessageCell()

            cell.setupCell(message: msg, isImageEnabled: imageEnabled, isUserNameEnabled: userNameEnabled)
            
            let tapGestureRecognizer = MyTapGestureRecognizer(target: self, action: #selector(self.cellUserImageTapped(_:)))
            tapGestureRecognizer.stringTag = msg.userID
            cell.imageView.addGestureRecognizer(tapGestureRecognizer)
            
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: outgoingTextMessageCellID,
                                                          for: indexPath) as? OutgoingTextMessageCell ?? OutgoingTextMessageCell()
 
            cell.setupCell(message: msg)
            
            return cell
        }
    }
    
    
    func getMetaForCell(indexPath : IndexPath) -> (msg : Message, cellHeight : CGFloat, isUserNameEnabled : Bool, isUserImageEnabled : Bool) {
        
        let sectionIndex = indexPath.section
        let msgIndex = indexPath.item
        let section = msgArray[sectionIndex]
        let msg = section[msgIndex]
        
        let bubbleHeight = estimateFrameForText(msg.text).height + (Constant.topBottomBubbleSpacing*2)
        
        guard let myUID = Auth.auth().currentUser?.uid else { return (msg, 0.0, false, false) }

        if myUID == msg.userID {
            let cellHeight = bubbleHeight
            return (msg, cellHeight, false, false)
        }
        
        var isUserNameEnabled = false
        if msgIndex == 0 {
            isUserNameEnabled = true
        }
        
        var isUserImageEnabled = false
        if msgIndex == section.count-1 {
            isUserImageEnabled = true
        }
        
        if isUserNameEnabled {
            let nameLabelHeight = estimateFrameForText(msg.userName).height
            let cellHeight = nameLabelHeight + bubbleHeight
            return (msg, cellHeight, isUserNameEnabled, isUserImageEnabled)
        } else {
            let cellHeight = bubbleHeight
            return (msg, cellHeight, isUserNameEnabled, isUserImageEnabled)
        }
        
    }
    
    func insertMsgIntoMsgArray(message msg : Message) -> (indexPath : IndexPath, newSectionCreated : Bool) {
        
        var createNewGroup = false
        if msgArray.isEmpty {
            createNewGroup = true
        }
        if let lastMsgGroup = msgArray.last, let lastMsg = lastMsgGroup.last {
            if lastMsg.userID != msg.userID {
                createNewGroup = true
            }
        }
        
        if createNewGroup == true {
            let newMsgGroup = [msg]
            msgArray.append(newMsgGroup)
        }
        else {
            msgArray[msgArray.count-1].append(msg)
        }
        
        let msgSection = msgArray.count-1
        let msgItem = msgArray[msgSection].count-1
        
        return (IndexPath(item: msgItem, section: msgSection), createNewGroup)
    }
    
    
}




extension ChatVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellMeta = getMetaForCell(indexPath: indexPath)
        return CGSize(width: self.collectionView.bounds.width, height: cellMeta.cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6.0, left: 0.0, bottom: 6.0, right: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 3.5
    }

}
