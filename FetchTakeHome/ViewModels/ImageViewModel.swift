//
//  ImageViewModel.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 2/1/24.
//

import Foundation
import SwiftUI
import UIKit

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var requestStatus: RequestStatus = .initiated
    private let imageFetcher = ImageFetcher.shared
    
    func getImage(urlString: String) {
        self.imageFetcher.getImage(urlString: urlString) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let image):
                    self?.image = image
                case .failure(let error):
                    Logger.logFailure(error)
                    self?.requestStatus = .failed
                }
            }
        }
    }
}
