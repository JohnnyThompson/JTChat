//
//  ImageServiceErrors.swift
//  JTChat
//
//  Created by Evgeny on 28.04.2022.
//

import Foundation

enum ImageServiceErrors: Error {
    case incorrectDataError
    case incorrectProtocol
}

extension ImageServiceErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectDataError:
            return "Incorrect data received from the server"
        case .incorrectProtocol:
            return "Incorrect protocol"
        }
    }
}
