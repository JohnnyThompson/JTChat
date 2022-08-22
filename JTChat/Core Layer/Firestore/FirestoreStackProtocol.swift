//
//  FirestoreStackProtocol.swift
//  JTChat
//
//  Created by Evgeny on 14.04.2022.
//

import FirebaseFirestore

protocol FirestoreStackProtocol {
    var dataBase: Firestore { get }
    func addSnapshotListener(type: CollectionReferenceType, channelId: String?, documentChange: @escaping (DocumentChange) -> Void)
    func change(type: CollectionReferenceType, action: FirestoreAction, dict: [String: Any]?, channelId: String?, identifier: String?)
}
