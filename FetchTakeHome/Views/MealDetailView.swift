//
//  MealDetailView.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 2/1/24.
//

import Foundation
import SwiftUI

struct MealDetailView: View {
    @ObservedObject var mealsViewModel: MealsViewModel
    @StateObject var router = Router.shared
    @Environment(\.colorScheme) var colorScheme
    let mealId: String
    
    var meal: Meal? {
        mealsViewModel.meals.first(where: { $0.id == self.mealId })
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    router.goHome()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundStyle(self.colorScheme == .dark ? .white : .black)
                        .padding()
                }

                Spacer()
            }

            if let meal = self.meal {
                ScrollView {
                    VStack {
                        if let url = URL(string: meal.imageURL) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "fork.knife.circle")
                                .resizable()
                                .frame(height: 200)
                        }
                                
                        Text(meal.name)
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .bold()
                                .italic()
                            
                            
                        Rectangle()
                            .frame(height: 2)
                            .foregroundStyle(.gray.opacity(0.5))
                        
                        if let ingredients = meal.ingredients {
                            VStack {
                                Text("Ingredients Required")
                                    .font(.title)
                                    .bold()
                                ForEach(ingredients) { ingredient in
                                    VStack {
                                        Text(ingredient.measurement + " of " + ingredient.name)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(height: 10)
                        
                        if let instructions = meal.instructions {
                            Text("Instructions")
                                .font(.title)
                                .bold()
                            Text(instructions)
                                .padding([.leading, .trailing])
                        }

                        Spacer()
                    }
                }
            } else {
                Spacer()
                Text("Oops, sorry -- something went wrong :(")
                Spacer()
            }
        }
        .onAppear {
            mealsViewModel.getDetails(of: self.mealId)
        }
    }
}


