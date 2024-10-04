//
//  FavoriteMealsListView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/30/24.
//

import MealsApi
import MealsApiLive
import MealDetails
import MealsRepo
import MealsRepoLive
import MealsUI
import SwiftUI

public struct FavoriteMealsListView: View {
    public init(model: FavoriteMealsListModel, onFavoriteButtonTapped: @escaping () -> Void) {
        self.model = model
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
    }

    let model: FavoriteMealsListModel
    let onFavoriteButtonTapped: () -> Void

    public var body: some View {
        NavigationStack {
            List(model.favorites) { meal in
                MealsListRowView(meal: meal,
                                 isFavorite: model.isFavorite(meal),
                                 onFavoriteButtonTapped: { model.onFavoriteButtonTapped(meal) })
            }
            .navigationDestination(for: Meal.self) { meal in
                MealDetailsView(model: MealDetailsModel(meal: meal,
                                                        apiClient: .live,
                                                        mealsRepo: MealsRepoLive.shared))
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onFavoriteButtonTapped) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .tint(Color.primary)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            model.onViewAppeared()
        }
    }
}

#Preview {
    FavoriteMealsListView(model: FavoriteMealsListModel(repo: MealsRepoTest()),
                          onFavoriteButtonTapped: {})
}
