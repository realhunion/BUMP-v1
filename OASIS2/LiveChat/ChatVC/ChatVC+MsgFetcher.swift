//
//  ChatVC+MessagesFetcherDelegate.swift
//  OASIS2
//
//  Created by Honey on 5/31/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase


extension ChatVC : MessageFetcherDelegate {
    
    
    func startMessageFetcher() {
        guard msgFetcher == nil else { return }
        
        msgFetcher = MessageFetcher(circleID: circleID, chatID: chatID)
        msgFetcher!.delegate = self
    }
    
    
    func newMessagesAdded(messages: [Message], initialLoadDone : Bool) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        DispatchQueue.main.async {
            self.stopSpinner()

        }
        
        if self.circleID == myUID {
            self.changeBadgeValue(override: false, by: 0)
        }
        
        
        // smooth initial load of >20 msgs.
        
        if !initialLoadDone {
            
            print("vvs 1 \(messages.count)")
            
            for m in messages {
                let _ = self.insertMsgIntoMsgArray(message: m)
            }
            DispatchQueue.main.async {
                UIView.transition(with: self.collectionView,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.collectionView.reloadData() })
                
                self.scrollToBottom(at: .bottom, isAnimated: true)
                self.inputBarView.isUserInteractionEnabled = true
            }
            
        } else {
            
            print("vvs 2 \(messages.count)")
            
            if self.inputBarView.isUserInteractionEnabled == false { return }
            
            self.collectionView.performBatchUpdates({
                
                for m in messages {
                    
                    //Report to chatVCDelegate NewMessage not-preloaded added
                    // Report to badge
                    if self.circleID == myUID {
                        self.changeBadgeValue(override: false, by: +1)
                    }
                    
                    let x = self.insertMsgIntoMsgArray(message: m)
                    let indexPath = x.indexPath
                    let newSectionCreated = x.newSectionCreated
                    
                    //refresh last cell
                    if newSectionCreated {
                        self.collectionView?.insertSections([indexPath.section])
                    } else {
                        self.collectionView?.insertItems(at: [indexPath])
                    }
                    
                    //refresh 2nd last cell also
                    if indexPath.item-1 >= 0 {
                        self.collectionView?.reloadItems(at: [IndexPath (item: indexPath.item - 1, section: indexPath.section)])
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.scrollToBottom(at: .bottom, isAnimated: true)
                }
                
            }, completion: { (isDone) in })
        }
    }
    
}
