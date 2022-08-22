//
//  ImagesNetworkServiceProtocol.swift
//  JTChat
//
//  Created by Evgeny on 28.04.2022.
//

protocol ImagesNetworkServiceProtocol {
    func fetchImages(completion:  @escaping (Result<Images, Error>) -> Void)
}
