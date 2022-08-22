//
//  ImageNetworkService.swift
//  JTChat
//
//  Created by Evgeny on 28.04.2022.
//

import Foundation

class ImagesNetworkService: ImagesNetworkServiceProtocol {
   
    // MARK: - Private properties
    
    private let networkStack: NetworkStackProtocol = NetworkStack()
    
    private var urlString: String {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "imagesAPI") as? String else {
            return ""
        }
        return urlString
    }
    
    // MARK: - Public methods
    
    func fetchImages(completion:  @escaping (Result<Images, Error>) -> Void) {
        networkStack.request(path: urlString) { (result: Result<ImageFetchResult, Error>) in
            switch result {
            case .success(let data):
                completion(.success(data.hits))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
