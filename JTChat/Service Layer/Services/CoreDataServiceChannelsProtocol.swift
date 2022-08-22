//
//  CoreDataServiceChannelsProtocol.swift
//  JTChat
//
//  Created by Evgeny on 10.05.2022.
//

import CoreData

protocol CoreDataServiceChannelsProtocol {
    var viewContext: NSManagedObjectContext { get }
    func addChannel(channel: Channel)
    func deleteChannel(channel: Channel)
    func modifyChannel(channel: Channel)
}
