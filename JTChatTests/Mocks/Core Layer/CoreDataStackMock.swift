//
//  CoreDataStackMock.swift
//  JTChatTests
//
//  Created by Evgeny on 18.05.2022.
//

@testable import JTChat
import CoreData

class CoreDataStackMock: CoreDataStackProtocol {
    var invokedViewContextGetter = false
    var invokedViewContextGetterCount = 0
    var stubbedViewContext: NSManagedObjectContext!

    var viewContext: NSManagedObjectContext {
        invokedViewContextGetter = true
        invokedViewContextGetterCount += 1
        return stubbedViewContext
    }

    var invokedPerformTaskOnMainQueueContextAndSave = false
    var invokedPerformTaskOnMainQueueContextAndSaveCount = 0
    var stubbedPerformTaskOnMainQueueContextAndSaveBlockResult: (NSManagedObjectContext, Void)?

    func performTaskOnMainQueueContextAndSave(_ block: @escaping (NSManagedObjectContext) -> Void) {
        invokedPerformTaskOnMainQueueContextAndSave = true
        invokedPerformTaskOnMainQueueContextAndSaveCount += 1
        if let result = stubbedPerformTaskOnMainQueueContextAndSaveBlockResult {
            block(result.0)
        }
    }
}
