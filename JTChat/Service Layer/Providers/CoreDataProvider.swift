//
//  CoreDataProvider.swift
//  JTChat
//
//  Created by Evgeny on 18.04.2022.
//

import Foundation

class CoreDataProvider {
    static let shared = CoreDataProvider()
    let coreDataStack = CoreDataStack()
    private init() { }
}
