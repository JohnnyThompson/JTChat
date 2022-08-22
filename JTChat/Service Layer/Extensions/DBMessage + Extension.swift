//
//  DBMessage + Extension.swift
//  JTChat
//
//  Created by Evgeny on 06.04.2022.
//

import CoreData

extension DBMessage {
    convenience init(message: Message, context: NSManagedObjectContext) {
        let entityName = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) ?? NSEntityDescription()
        self.init(entity: entity, insertInto: context)
        content = message.content
        created = message.created
        senderId = message.senderId
        senderName = message.senderName
        identifier = message.identifier
    }
}
