//
//  StorageService.swift
//  JTChat
//
//  Created by Evgeny on 20.04.2022.
//

import Foundation

class StorageService: StorageServiceProtocol {
    
    // MARK: - Private properties
    
    private let storageStack: StorageStackProtocol = StorageStack()
    private let logIsEnable: Bool
    
    // MARK: - Initialization
    
    init(logIsEnable: Bool = false) {
        self.logIsEnable = logIsEnable
    }
    
    // MARK: - Public methods
    
    func savePhoto(data: Data?) {
        storageStack.saveImageToFile(data: data)
    }
    func loadPhoto() -> Data? {
        storageStack.loadImageFromFile()
    }
    func deletePhoto() {
        storageStack.removeProfileImage()
    }
}
