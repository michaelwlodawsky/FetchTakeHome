//
//  RootView.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 2/1/24.
//

import Foundation
import SwiftUI

struct RootView: View {
    @StateObject var router: Router = .shared
    @StateObject var mealsViewModel = MealsViewModel()

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView(mealsViewModel: self.mealsViewModel)
                .navigationTitle("Dessert List")
                .navigationDestination(for: Meal.self) { meal in
                    MealDetailView(mealsViewModel: self.mealsViewModel, mealId: meal.id)
                        .toolbar(.hidden, for: .automatic)
                }
                .ignoresSafeArea(edges: [.bottom])
        }
    }
}

#Preview {
    RootView()
}
