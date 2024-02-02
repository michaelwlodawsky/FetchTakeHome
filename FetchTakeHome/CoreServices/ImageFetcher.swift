//
//  ImageFetcher.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 2/1/24.
//

import Foundation
import UIKit

/// Enumerations describing the error that occurred when fetching an image
enum ImageError: Error {
    case invalidURL
    case urlSessionError(Error)
    case invalidImageData
    case noData
}

/// Singleton service for fetching image data from the server
class ImageFetcher {
    static let shared = ImageFetcher()
    
    /// Get an image from the server.
    ///
    /// - parameter urlString: The url string for the `URLRequest`
    /// - parameter completion: Callback once the fetching is complete with the `Result<UIImage, ImageError>`
    func getImage(urlString: String, _ completion: @escaping (Result<UIImage, ImageError>) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidURL))
        }
    
        URLSession.shared.dataTask(with: .init(url: url)) { data, _, error in
            if let error {
                return completion(.failure(.urlSessionError(error)))
            }
            
            guard let data else {
                return completion(.failure(.noData))
            }
            
            if let image = UIImage(data: data) {
                return completion(.success(image))
            } else {
                return completion(.failure(.invalidImageData))
            }
        }
        .resume()
    }
}
