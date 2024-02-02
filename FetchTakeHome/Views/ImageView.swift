//
//  ImageView.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 2/1/24.
//

import Foundation
import SwiftUI

struct ImageView: View {
    @StateObject var imageViewModel = ImageViewModel()
    let urlString: String

    var body: some View {
        VStack {
            if let image = imageViewModel.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                if imageViewModel.requestStatus == .failed {
                    Image(systemName: "fork.knife.circle")
                        .resizable()
                } else {
                    ProgressView()
                }
            }
        }
        .onAppear {
            self.imageViewModel.getImage(urlString: self.urlString)
        }
    }
}
