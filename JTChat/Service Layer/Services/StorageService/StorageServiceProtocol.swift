//
//  StorageServiceProtocol.swift
//  JTChat
//
//  Created by Evgeny on 20.04.2022.
//

import Foundation

protocol StorageServiceProtocol {
    func savePhoto(data: Data?)
    func loadPhoto() -> Data?
    func deletePhoto()

}
