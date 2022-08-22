//
//  StorageStack.swift
//  JTChat
//
//  Created by Евгений Карпов on 20.03.2022.
//

import UIKit

final class StorageStack: StorageStackProtocol {
   
    // MARK: - Properties
    
    private let manager = FileManager.default
    
    private var imageURL: URL {
        return getDocumentsDirectory().appendingPathComponent(.profileImagePathComponent)
    }
    
    // MARK: - Public methods
    
    func saveImageToFile(data: Data?) {
        if let data = data {
            try? data.write(to: imageURL)
        }
    }
    
    func loadImageFromFile() -> Data? {
        return manager.contents(atPath: imageURL.path)
    }
    
    func removeProfileImage() {
        if manager.fileExists(atPath: imageURL.path) {
            do {
                try manager.removeItem(at: imageURL)
            } catch {
                print(error)
            }
        }
    }
    // MARK: - Private methods
    
    private func getDocumentsDirectory() -> URL {
        let path = manager.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}
