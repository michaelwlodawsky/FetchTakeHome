//
//  Meals.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 2/1/24.
//

import Foundation
import SwiftUI

/// ViewModel to plug into a Swiftui View
class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var initialRequestStatus: RequestStatus = .initiated
    @Published var mealDetailsFetched: Set<String> = []
    
    init() {
        // Note: Given data size and structure, pagination was not utilized
        // in this implementation. 
        MealManager.shared.getDesserts { result in
            switch result {
            case .success(let meals):
                DispatchQueue.main.async { [weak self] in
                    self?.meals = meals.sorted(by: { $0.name > $1.name })
                    self?.initialRequestStatus = .succeeded
                }

            case .failure:
                DispatchQueue.main.async { [weak self] in
                    self?.initialRequestStatus = .failed
                }
            }
        }
    }
    
    func getDetails(of mealId: String) {
        guard !mealDetailsFetched.contains(mealId) else {
            return // No need to fetch details more than once at this time
        }

        MealManager.shared.getMealDetails(mealId: mealId) { [weak self] result in
            switch result {
            case .success(let meal):
                if let mealToIndex = self?.meals.first(where: { $0.id == mealId }),
                    let index = self?.meals.firstIndex(of: mealToIndex) {
                    DispatchQueue.main.async {
                        self?.meals[index] = meal
                        self?.mealDetailsFetched.insert(mealId)
                    }
                }
                
            case .failure:
                break // UI can handle failure, we will still have a cached object with title + img
            }
        }
    }
}
