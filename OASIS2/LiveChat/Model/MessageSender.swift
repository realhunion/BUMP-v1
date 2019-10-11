//
//  MessageSender.swift
//  OASIS2
//
//  Created by Honey on 6/6/19.
//  Copyright © 2019 theDevHoney. All rights reserved.
//

import Foundation
import Firebase

class MessageSender {
    
    var circleID : String
    var chatID : String
    
    init(circleID : String, chatID : String) {
        self.circleID = circleID
        self.chatID = chatID
    }
    
    deinit {
        print("vv msgSender DE INIT")
    }
    
    
    func postTextToFirebase(text : String) {
        
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        
        guard let userProfileDict = UserDefaults.standard.value(forKey: "userProfileDict") as? [String:Any], let userName = userProfileDict["userName"] as? String else { return }
        
        let db = Firestore.firestore()
        let timestamp = generateUniqueTimestamp()
        
        let firstName = userName.split(separator: " ")[0]
        
        let data = generateMsgDataStrip(text: text, userID: myUID, userName: String(firstName))
    db.collection("Circles").document(circleID).collection("Chats").document(chatID).collection("Messages").document(timestamp).setData(data)
        
    }
    
    
    func generateMsgDataStrip(text : String, userID : String, userName : String) -> [String:Any] {
        
        let currentDate = Date()
    
        let data = [
            "text": text,
            "userID": userID,
            "userName": userName,
            "timestamp": currentDate,
            ] as [String : Any]
        
        return data
    }
    
    func generateUniqueTimestamp() -> String {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "MMddHHmmssSSS"
        let timestamp = df.string(from: d)
        df.timeStyle = .medium
        let timestamp2 = df.string(from: d)
        let finalTimestamp = numCharConversion(theString: timestamp) + " " + timestamp2
        // -> zxysyxuuzvusw 12:55:04 PM
        return finalTimestamp
    }
    
    func numCharConversion(theString : String) -> String {
        var s = theString
        s = s.replacingOccurrences(of: "0", with: "z")
        s = s.replacingOccurrences(of: "1", with: "y")
        s = s.replacingOccurrences(of: "2", with: "x")
        s = s.replacingOccurrences(of: "3", with: "w")
        s = s.replacingOccurrences(of: "4", with: "v")
        s = s.replacingOccurrences(of: "5", with: "u")
        s = s.replacingOccurrences(of: "6", with: "t")
        s = s.replacingOccurrences(of: "7", with: "s")
        s = s.replacingOccurrences(of: "8", with: "r")
        s = s.replacingOccurrences(of: "9", with: "q")
        return s
    }
    
    
    
}
