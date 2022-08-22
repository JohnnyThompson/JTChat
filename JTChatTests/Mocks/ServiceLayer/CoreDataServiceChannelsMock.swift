//
//  CoreDataServiceChannelsMock.swift
//  JTChatTests
//
//  Created by Evgeny on 18.05.2022.
//

@testable import JTChat
import CoreData

class CoreDataServiceChannelsMock: CoreDataServiceChannelsProtocol {
    var invokedViewContextGetter = false
    var invokedViewContextGetterCount = 0
    var stubbedViewContext: NSManagedObjectContext!

    var viewContext: NSManagedObjectContext {
        invokedViewContextGetter = true
        invokedViewContextGetterCount += 1
        return stubbedViewContext
    }

    var invokedAddChannel = false
    var invokedAddChannelCount = 0
    var invokedAddChannelParameters: (channel: Channel, Void)?
    var invokedAddChannelParametersList = [(channel: Channel, Void)]()

    func addChannel(channel: Channel) {
        invokedAddChannel = true
        invokedAddChannelCount += 1
        invokedAddChannelParameters = (channel, ())
        invokedAddChannelParametersList.append((channel, ()))
    }

    var invokedDeleteChannel = false
    var invokedDeleteChannelCount = 0
    var invokedDeleteChannelParameters: (channel: Channel, Void)?
    var invokedDeleteChannelParametersList = [(channel: Channel, Void)]()

    func deleteChannel(channel: Channel) {
        invokedDeleteChannel = true
        invokedDeleteChannelCount += 1
        invokedDeleteChannelParameters = (channel, ())
        invokedDeleteChannelParametersList.append((channel, ()))
    }

    var invokedModifyChannel = false
    var invokedModifyChannelCount = 0
    var invokedModifyChannelParameters: (channel: Channel, Void)?
    var invokedModifyChannelParametersList = [(channel: Channel, Void)]()

    func modifyChannel(channel: Channel) {
        invokedModifyChannel = true
        invokedModifyChannelCount += 1
        invokedModifyChannelParameters = (channel, ())
        invokedModifyChannelParametersList.append((channel, ()))
    }
}
