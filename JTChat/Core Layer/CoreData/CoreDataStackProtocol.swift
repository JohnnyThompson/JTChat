//
//  CoreDataStackProtocol.swift
//  JTChat
//
//  Created by Evgeny on 07.04.2022.
//

import CoreData

protocol CoreDataStackProtocol {
    var viewContext: NSManagedObjectContext { get }
    func performTaskOnMainQueueContextAndSave(_ block: @escaping (NSManagedObjectContext) -> Void)
}
