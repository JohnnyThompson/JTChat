//
//  FirestoreServiceChannelsMock.swift
//  JTChatTests
//
//  Created by Evgeny on 18.05.2022.
//

@testable import JTChat

class FirestoreServiceChannelsMock: FirestoreServiceChannelsProtocol {
    var invokedAddChannelsSnapshotListener = false
    var invokedAddChannelsSnapshotListenerCount = 0
    var stubbedAddChannelsSnapshotListenerAddedResult: (Channel, Void)?
    var stubbedAddChannelsSnapshotListenerModifiedResult: (Channel, Void)?
    var stubbedAddChannelsSnapshotListenerDeletedResult: (Channel, Void)?

    func addChannelsSnapshotListener(
        added: @escaping (Channel) -> Void,
        modified: @escaping (Channel) -> Void,
        deleted: @escaping (Channel) -> Void
    ) {
        invokedAddChannelsSnapshotListener = true
        invokedAddChannelsSnapshotListenerCount += 1
        if let result = stubbedAddChannelsSnapshotListenerAddedResult {
            added(result.0)
        }
        if let result = stubbedAddChannelsSnapshotListenerModifiedResult {
            modified(result.0)
        }
        if let result = stubbedAddChannelsSnapshotListenerDeletedResult {
            deleted(result.0)
        }
    }

    var invokedAddChanel = false
    var invokedAddChanelCount = 0
    var invokedAddChanelParameters: (channel: Channel, Void)?
    var invokedAddChanelParametersList = [(channel: Channel, Void)]()

    func addChanel(channel: Channel) {
        invokedAddChanel = true
        invokedAddChanelCount += 1
        invokedAddChanelParameters = (channel, ())
        invokedAddChanelParametersList.append((channel, ()))
    }

    var invokedDeleteChannel = false
    var invokedDeleteChannelCount = 0
    var invokedDeleteChannelParameters: (channelId: String, Void)?
    var invokedDeleteChannelParametersList = [(channelId: String, Void)]()

    func deleteChannel(channelId: String) {
        invokedDeleteChannel = true
        invokedDeleteChannelCount += 1
        invokedDeleteChannelParameters = (channelId, ())
        invokedDeleteChannelParametersList.append((channelId, ()))
    }
}
