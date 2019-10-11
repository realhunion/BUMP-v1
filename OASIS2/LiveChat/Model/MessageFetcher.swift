//
//  MessagesFetcher.swift
//  OASIS2
//
//  Created by Honey on 5/31/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase


protocol MessageFetcherDelegate: class {
    func newMessagesAdded(messages : [Message], initialLoadDone : Bool)
}

class MessageFetcher {
    
    let numMessagesToLoad = 20
    let lastXSecondsToLoad = 180
    let lastXSecondsToLoadLive = 5
    
    let db = Firestore.firestore()
    var listener : ListenerRegistration?
    
    weak var delegate: MessageFetcherDelegate?
    
    var circleID : String
    var chatID : String
    init(circleID : String, chatID : String) {
        self.circleID = circleID
        self.chatID = chatID
        startMonitor()
        
        print("vv msgfetcher INIT \(circleID)")
    }
    
    deinit {
        print("vv msgfetcher DE INIT \(circleID)")
    }
    
    var initialLoadDone = false
    
    func startMonitor() {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("Circles").document(circleID).collection("Chats").document(chatID).collection("Messages").limit(to: numMessagesToLoad)
        listener = ref.addSnapshotListener(includeMetadataChanges: false, listener: { (snap, err) in
            guard let docChanges = snap?.documentChanges else {
                //error
                return
            }
            
            if !self.initialLoadDone {
                var msgs : [Message] = []
                docChanges.reversed().forEach { diff in
                    if (diff.type == .added) {
                        let data = diff.document.data()
                        if let userID = data["userID"] as? String,
                            let userName = data["userName"] as? String,
                            let text = data["text"] as? String,
                            let timestamp = data["timestamp"] as? Timestamp {
                            
                            let currentTime = Int64(Date().timeIntervalSince1970)
                            let difference = currentTime - timestamp.seconds
                            if difference >= 0 && difference <= Int64(self.lastXSecondsToLoad) {
                                //if msg less than X seconds old
                                
                                let msg : Message = Message(userID: userID, userName: userName, text: text)
                                msgs.append(msg)
                                
                            }
                            
                        }
                    }
                }
                self.initialLoadDone = true
                self.delegate?.newMessagesAdded(messages: msgs, initialLoadDone: false)
            }
            else {
                docChanges.forEach({ (diff) in
                    if (diff.type == .added) {
                        let data = diff.document.data()
                        if let userID = data["userID"] as? String,
                            let userName = data["userName"] as? String,
                            let text = data["text"] as? String,
                            let timestamp = data["timestamp"] as? Timestamp {
                            
                            //make sure msg received within 5 seconds else ew.
                            let currentTime = Int64(Date().timeIntervalSince1970)
                            let difference = currentTime - timestamp.seconds
                            if difference >= 0 && difference <= Int64(self.lastXSecondsToLoad) && myUID != userID {
                            
                                let msg : Message = Message(userID: userID, userName: userName, text: text)
                                self.delegate?.newMessagesAdded(messages: [msg], initialLoadDone: true)
                            }
                        }
                        
                    }
                })
            }
        })
    }
    
    func shutDown() {
        if let listenr = listener {
            listenr.remove()
        }
        self.delegate = nil
    }
    
    
    
    
    
    
    
}
