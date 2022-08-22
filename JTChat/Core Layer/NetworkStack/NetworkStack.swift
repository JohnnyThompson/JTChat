//
//  NetworkService.swift
//  JTChat
//
//  Created by Evgeny on 27.04.2022.
//

import Foundation

class NetworkStack: NetworkStackProtocol {
    func request<T: Decodable>(
        path: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: path) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkStackError.serverError(error: error)))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.failure(NetworkStackError.noConnectionError))
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkStackError.incorrectDataError))
                }
            }
        }
        task.resume()
    }
}
