//
//  CoreDataServiceMessagesProtocol.swift
//  JTChat
//
//  Created by Evgeny on 19.04.2022.
//

import CoreData

protocol CoreDataServiceMessagesProtocol {
    var viewContext: NSManagedObjectContext { get }
    func getPerson() -> DBPerson?
    func addMessage(message: Message, to channel: DBChannel)
    func deleteMessage(message: Message, on channel: DBChannel)
    func modifyMessage(message: Message, on channel: DBChannel)
}
