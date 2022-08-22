//
//  NetworkServiceError.swift
//  JTChat
//
//  Created by Evgeny on 27.04.2022.
//

import Foundation

enum NetworkStackError: Error {
    case incorrectDataError
    case noConnectionError
    case serverError(error: Error)
}

extension NetworkStackError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectDataError:
            return "Incorrect data received from the server"
        case .noConnectionError:
            return "No connection to the server"
        case .serverError(let error):
            return "Server error - \(error.localizedDescription)"
        }
    }
}
