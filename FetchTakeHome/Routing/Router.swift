//
//  Router.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 2/1/24.
//

import Foundation
import SwiftUI

/// Router containing the navigation path meant to be shared via environment variable.
class Router: ObservableObject {
    @Published var path: NavigationPath = .init()
    static let shared = Router()
    
    func goHome() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else {
                return
            }

            this.path.removeLast(this.path.count)
        }
    }
}
