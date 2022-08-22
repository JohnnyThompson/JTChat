//
//  Channel.swift
//  JTChat
//
//  Created by Евгений Карпов on 07.03.2022.
//

import Foundation
import FirebaseFirestore

typealias Channels = [Channel]

struct Channel: Codable {
    
    // MARK: - Properties
    
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    // MARK: - Initialization
    
    init(channelName: String) {
        identifier = "Channel identifier"
        name = channelName
        lastMessage = "No messages yet"
        lastActivity = Date()
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String else {
            return nil
        }
        
        self.identifier = document.documentID
        self.name = name
        
        if let lastMessage = data["lastMessage"] as? String {
            self.lastMessage = lastMessage
        } else {
            lastMessage = "No messages yet"
        }
        
        if let lastActivity = data["lastActivity"] as? Timestamp {
            self.lastActivity = Date(timeIntervalSince1970: TimeInterval(lastActivity.seconds))
        } else {
            lastActivity = nil
        }
    }
}

extension Channel {
    var toDict: [String: Any] {
        var dict: [String: Any] = ["identifier": identifier,
                                   "name": name]
        
        if let lastMessage = lastMessage {
            dict["lastMessage"] = lastMessage
        }
        
        if let lastActivity = lastActivity {
            dict["lastActivity"] = Timestamp(date: lastActivity)
        }
        
        return dict
    }
}
