//
//  DBChannel + Extension.swift
//  JTChat
//
//  Created by Evgeny on 06.04.2022.
//

import CoreData

extension DBChannel {
    convenience init(channel: Channel, context: NSManagedObjectContext) {
        let entityName = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) ?? NSEntityDescription()
        self.init(entity: entity, insertInto: context)
        name = channel.name
        identifier = channel.identifier
        lastActivity = channel.lastActivity
        lastMessage = channel.lastMessage
    }
}
