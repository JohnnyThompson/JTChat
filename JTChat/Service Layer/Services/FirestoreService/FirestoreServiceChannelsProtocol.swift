//
//  FirestoreServiceChannelsProtocol.swift
//  JTChat
//
//  Created by Evgeny on 19.04.2022.
//

protocol FirestoreServiceChannelsProtocol {
    func addChannelsSnapshotListener(
        added: @escaping (Channel) -> Void,
        modified: @escaping (Channel) -> Void,
        deleted: @escaping (Channel) -> Void
    )
    func addChanel(channel: Channel)
    func deleteChannel(channelId: String)
}
