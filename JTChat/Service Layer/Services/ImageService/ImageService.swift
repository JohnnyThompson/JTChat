//
//  ImageService.swift
//  JTChat
//
//  Created by Evgeny on 27.04.2022.
//

import Foundation

class ImageService: ImageServiceProtocol {
    
    // MARK: - Private properties
    
    private var imageCache = NSCache<NSString, NSData>()
    
    // MARK: - Public methods
    
    func getImageData(with urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageFromCache = imageCache.object(forKey: urlString as NSString) as Data?  else {
            guard urlString.hasPrefix("https") else {
                completion(.failure(ImageServiceErrors.incorrectProtocol))
                return
            }
            
            guard let url = URL(string: urlString) else {
                return
            }
            
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
                DispatchQueue.main.async {
                    guard let data = data else {
                        completion(.failure(ImageServiceErrors.incorrectDataError))
                        return
                    }
                    
                    completion(.success(data))
                    self.imageCache.setObject(NSData(data: data), forKey: urlString as NSString)
                }
            }
            task.resume()
            return
        }
        completion(.success(imageFromCache))
    }
}
