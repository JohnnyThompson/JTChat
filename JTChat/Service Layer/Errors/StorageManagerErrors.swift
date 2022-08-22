//
//  StorageManagerErrors.swift
//  JTChat
//
//  Created by Evgeny on 24.03.2022.
//

import Foundation

enum StorageManagerError: Error {
    case accessError
    case typecastingError
    case writingError
}

extension StorageManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accessError:
            return "Ошибка доступа к файлу"
        case .typecastingError:
            return "Ошибка конвертации данных"
        case .writingError:
            return "Ошибка записи"
        }
    }
}
