//
//  FirestoreStack.swift
//  JTChat
//
//  Created by Evgeny on 28.03.2022.
//

import FirebaseFirestore

final class FirestoreStack: FirestoreStackProtocol {
    
    // MARK: - Properties
    
    let dataBase = Firestore.firestore()
    private var channelsReference: CollectionReference {
        dataBase.collection("channels")
    }
    
    // MARK: - Public methods
    
    func addSnapshotListener(type: CollectionReferenceType, channelId: String?, documentChange: @escaping (DocumentChange) -> Void) {
        switch type {
        case .channels:
            channelsReference.addSnapshotListener { querySnapshot, _ in
                guard let snapshot = querySnapshot else {
                    print("Firestore: Error fetching snapshots")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    documentChange(diff)
                }
            }
        case .messages:
            guard let channelId = channelId else {
                return
            }
            
            let messagesReference = channelsReference.document(channelId).collection("messages")
            messagesReference.addSnapshotListener { querySnapshot, _ in
                guard let snapshot = querySnapshot else {
                    print("Firestore: Error fetching snapshots")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    documentChange(diff)
                }
            }
        }
    }
    
    func change(type: CollectionReferenceType, action: FirestoreAction, dict: [String: Any]?, channelId: String?, identifier: String?) {
        switch type {
        case .channels:
            switch action {
            case .add:
                guard let dict = dict else {
                    return
                }
                
                channelsReference.addDocument(data: dict)
            case .delete:
                guard let channelId = channelId else {
                    return
                }
                
                channelsReference.document(channelId).delete()
            }
        case .messages:
            guard let channelId = channelId else {
                return
            }
            
            let messagesReference = channelsReference.document(channelId).collection("messages")
            
            switch action {
            case .add:
                guard let dict = dict else {
                    return
                }
                
                messagesReference.addDocument(data: dict)
            case .delete:
                guard let identifier = identifier else {
                    return
                }
                
                messagesReference.document(identifier).delete()
            }
        }
    }
}
