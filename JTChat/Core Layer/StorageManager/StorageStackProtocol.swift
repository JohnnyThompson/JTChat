//
//  StorageStackProtocol.swift
//  JTChat
//
//  Created by Евгений Карпов on 20.03.2022.
//

import Foundation

protocol StorageStackProtocol {
    func saveImageToFile(data: Data?)
    func loadImageFromFile() -> Data?
    func removeProfileImage()
}
