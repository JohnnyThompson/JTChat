//
//  FirestoreService.swift
//  JTChat
//
//  Created by Evgeny on 19.04.2022.
//

import FirebaseFirestore

final class FirestoreService {
    
    // MARK: - Private properties
    
    var firestoreStack: FirestoreStackProtocol = FirestoreStack()

    private var logIsEnable: Bool = false
    
    // MARK: - Initialization
    
    init(logIsEnable: Bool = false) {
        self.logIsEnable = logIsEnable
    }
    
    // MARK: - Private methods
    
    private func printMessage(_ message: String) {
        if logIsEnable {
            print(message)
        }
    }
}

// MARK: - FirestoreServiceChannelsProtocol

extension FirestoreService: FirestoreServiceChannelsProtocol {
    func addChannelsSnapshotListener(
        added: @escaping (Channel) -> Void,
        modified: @escaping (Channel) -> Void,
        deleted: @escaping (Channel) -> Void
    ) {
        firestoreStack.addSnapshotListener(type: .channels, channelId: nil) { [weak self] diff in
            switch diff.type {
            case .added:
                guard let channel = Channel(document: diff.document) else {
                    self?.printMessage("Firestore: Channel adding failed")
                    return
                }
                
                added(channel)
                
                self?.printMessage("Firestore: New channel added: \(channel.identifier)")
            case .modified:
                guard let channel = Channel(document: diff.document) else {
                    self?.printMessage("Firestore: Channel modifying failed")
                    return
                }
                
                modified(channel)
                
                self?.printMessage("Firestore: Channel \(channel.identifier) modified")
            case .removed:
                guard let channel = Channel(document: diff.document) else {
                    self?.printMessage("Firestore: Channel deleting failed")
                    return
                }
                
                deleted(channel)
                
                self?.printMessage("Firestore: Channel \(channel.identifier) was deleted")
            }
        }
    }
    
    func addChanel(channel: Channel) {
        let dict = channel.toDict
        firestoreStack.change(type: .channels, action: .add, dict: dict, channelId: nil, identifier: nil)
    }
    
    func deleteChannel(channelId: String) {
        firestoreStack.change(type: .channels, action: .delete, dict: nil, channelId: channelId, identifier: nil)
    }
}
// MARK: - FirestoreServiceMessagesProtocol

extension FirestoreService: FirestoreServiceMessagesProtocol {
    func addMessagesSnapshotListener(
        for channelId: String,
        added: @escaping (Message) -> Void,
        modified: @escaping (Message) -> Void,
        deleted: @escaping (Message) -> Void
    ) {
        firestoreStack.addSnapshotListener(type: .messages, channelId: channelId) { [weak self] diff in
            switch diff.type {
            case .added:
                guard let message = Message(document: diff.document) else {
                    self?.printMessage("Firestore: Channel adding failed")
                    return
                }
                
                added(message)
                
                self?.printMessage("Firestore: New message added: \(message.identifier ?? "")")
            case .modified:
                guard let message = Message(document: diff.document) else {
                    self?.printMessage("Firestore: Message modifying failed")
                    return
                }
                
                modified(message)
                
                self?.printMessage("Firestore: Message \(message.identifier ?? "") modified")
            case .removed:
                guard let message = Message(document: diff.document) else {
                    self?.printMessage("Firestore: Message deleting failed")
                    return
                }
                
                deleted(message)
                
                self?.printMessage("Firestore: Message \(message.identifier ?? "") was deleted")
            }
        }
    }
    
    func sendMessage(message: Message, for channelId: String) {
        let dict = message.toDict
        firestoreStack.change(type: .messages, action: .add, dict: dict, channelId: channelId, identifier: nil)
    }
    
    func deleteMessage(message: DBMessage, for channelId: String) {
        guard let identifier = message.identifier else {
            return
        }
        
        firestoreStack.change(type: .messages, action: .delete, dict: nil, channelId: channelId, identifier: identifier)
    }
}
