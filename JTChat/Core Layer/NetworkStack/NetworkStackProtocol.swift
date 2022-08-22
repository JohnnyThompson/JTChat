//
//  NetworkServiceProtocol.swift
//  JTChat
//
//  Created by Evgeny on 27.04.2022.
//

import Foundation

protocol NetworkStackProtocol {
    func request<T: Decodable>(
        path: String,
        completion: @escaping (Result<T, Error>) -> Void
    )
}
