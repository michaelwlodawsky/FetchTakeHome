//
//  ContentView.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 1/31/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var mealsViewModel: MealsViewModel
    @StateObject var router = Router.shared
    
    var body: some View {
        if mealsViewModel.initialRequestStatus == .initiated {
            ProgressView()
        } else if mealsViewModel.initialRequestStatus == .failed {
            Text("Whoops, something went wrong :(")
                .font(.largeTitle)
            Text("Try Restarting the App!")
                .font(.headline)
        } else if mealsViewModel.initialRequestStatus == .succeeded {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(mealsViewModel.meals, id: \.id) { meal in
                        Button(action: {
                            router.path.append(meal)
                        }, label: {
                            HStack {
                                ImageView(urlString: meal.imageURL)
                                    .frame(width: 50, height: 50)
                                Text(meal.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        })
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
            .scrollIndicators(.hidden)
        }

        
        
    }
}
