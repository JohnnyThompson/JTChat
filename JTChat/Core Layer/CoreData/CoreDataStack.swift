//
//  CoreDataStack.swift
//  JTChat
//
//  Created by Evgeny on 05.04.2022.
//

import CoreData

class CoreDataStack: CoreDataStackProtocol {
    
    // MARK: - Public properties
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    var backgroundContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    // MARK: - Private properties
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        
        return container
    }()

    // MARK: - Public methods
    
    func performTaskOnMainQueueContextAndSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        viewContext.performAndWait {
            block(viewContext)
        }
        saveViewContext()
    }
    
    // MARK: - Private methods
  
    private func saveViewContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
