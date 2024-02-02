//
//  MealManager.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 1/31/24.
//

import Foundation

private let kDessertEndpoint = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
private let kMealDetailsEndpoint = "https://themealdb.com/api/json/v1/1/lookup.php?i="

/// Enumeration describing the error types for the API `Result`.
enum MealError: Error {
    /// Invalid URL was used for the request.
    case invalidURL
    /// There was an error with the `URLSession`.
    case urlSessionError(Error?)
    /// There was an error when decoding the JSON data.
    case decodingError(Error?)
    /// There was no data received from the session.
    case noData
}


/// Private wrapper to extract list from json dictionary
private struct MealWrapper: Codable {
    /// List of meals returned from the query, should be
    /// of size 1 for `getMealDetails(:)`
    let meals: [Meal]
}

/// Singleton manager for fetching meal information.
class MealManager {
    static let shared = MealManager()

    /// Get the list of desserts from the server.
    ///
    /// - parameter completion: The callback upon completing the request with a `Result<[Meal], MealError>`.
    func getDesserts(_ completion: @escaping (Result<[Meal], MealError>) -> ()) {
        guard let url = URL(string: kDessertEndpoint) else {
            return completion(.failure(.invalidURL))
        }
        
        URLSession.shared.dataTask(with: .init(url: url)) { data, _, error in
            guard error == nil else {
                return completion(.failure(.urlSessionError(error)))
            }
            
            guard let data else {
                return completion(.failure(.noData))
            }
            
            do {
                let mealWrapper = try JSONDecoder().decode(MealWrapper.self, from: data)
                completion(.success(mealWrapper.meals))
            } catch {
                return completion(.failure(.decodingError(error)))
            }
        }
        .resume()
    }
    
    /// Get details of the meal based on the id.
    ///
    /// - parameter mealId: The string identifier of the meal.
    /// - parameter completion: Completion to handle success or failure of the request based on `Result<Meal, MealError>`
    func getMealDetails(mealId: String, _ completion: @escaping (Result<Meal, MealError>) -> Void) {
        guard let url = URL(string: kMealDetailsEndpoint + mealId) else {
            return completion(.failure(.invalidURL))
        }
        
        URLSession.shared.dataTask(with: .init(url: url)) { data, _, error in
            guard error == nil else {
                return completion(.failure(.urlSessionError(error)))
            }
            
            guard let data else {
                return completion(.failure(.noData))
            }
            
            do {
                let mealWrapper = try JSONDecoder().decode(MealWrapper.self, from: data)
                if !mealWrapper.meals.isEmpty {
                    completion(.success(mealWrapper.meals[0]))
                } else {
                    completion(.failure(.noData))
                }
            } catch {
                return completion(.failure(.decodingError(error)))
            }
        }
        .resume()
    }
}
