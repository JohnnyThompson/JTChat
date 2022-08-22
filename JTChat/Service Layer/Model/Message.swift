//
//  Message.swift
//  JTChat
//
//  Created by Евгений Карпов on 07.03.2022.
//

import Foundation
import FirebaseFirestore

typealias Messages = [Message]

struct Message: Codable {
    
    // MARK: - Properties
    
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    var identifier: String?
    
    // MARK: - Initialization
    
    init(messageText: String, fullName: String) {
        content = messageText
        created = Date()
        senderId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        senderName = fullName
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        identifier = document.documentID
        
        guard let content = data["content"] as? String,
              let created = data["created"] as? Timestamp,
              let senderName = data["senderName"] as? String
        else {
            return nil
        }
        
        self.content = content
        self.created = Date(timeIntervalSince1970: TimeInterval(created.seconds))
        self.senderName = senderName
        self.senderId = data["senderId"] as? String ?? "SenderID not set"
    }
}
// MARK: - toDict

extension Message {
    var toDict: [String: Any] {
        return ["content": content,
                "created": Timestamp(date: created),
                "senderId": senderId,
                "senderName": senderName]
    }
}
