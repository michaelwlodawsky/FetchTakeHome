//
//  Logger.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 2/2/24.
//

import Foundation

/// A class for adding fancy logging capabilities like remote bug tracking
/// and custom error handling
class Logger {
    static func logFailure(_ error: Error) {
        print(error.localizedDescription)
    }
}
