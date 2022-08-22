//
//  DBPerson + Extension.swift
//  JTChat
//
//  Created by Evgeny on 20.04.2022.
//

import CoreData

extension DBPerson {
    convenience init(fullName: String, aboutMe: String, location: String, context: NSManagedObjectContext) {
        let entityName = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) ?? NSEntityDescription()
        self.init(entity: entity, insertInto: context)
        self.fullName = fullName
        self.aboutMe = aboutMe
        self.location = location
    }
}
