//
//  ImageServiceProtocol.swift
//  JTChat
//
//  Created by Evgeny on 27.04.2022.
//

import Foundation

protocol ImageServiceProtocol {
    func getImageData(with urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}
