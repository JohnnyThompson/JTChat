//
//  Image.swift
//  JTChat
//
//  Created by Evgeny on 28.04.2022.
//

import Foundation

struct ImageFetchResult: Codable {
    let hits: Images
}

typealias Images = [Image]

struct Image: Codable {
    let previewURL: String
    let webformatURL: String
}
