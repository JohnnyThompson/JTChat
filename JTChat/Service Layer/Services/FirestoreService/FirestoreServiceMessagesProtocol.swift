//
//  FirestoreServiceMessagesProtocol.swift
//  JTChat
//
//  Created by Evgeny on 10.05.2022.
//

protocol FirestoreServiceMessagesProtocol {
    func addMessagesSnapshotListener(
        for channelId: String,
        added: @escaping (Message) -> Void,
        modified: @escaping (Message) -> Void,
        deleted: @escaping (Message) -> Void
    )
    func sendMessage(message: Message, for channelId: String)
    func deleteMessage(message: DBMessage, for channelId: String)
}
