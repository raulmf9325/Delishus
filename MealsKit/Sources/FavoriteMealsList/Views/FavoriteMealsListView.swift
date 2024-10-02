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
import MealsUI
import SwiftUI

public struct FavoriteMealsListView: View {
    public init(model: FavoriteMealsListModel) {
        self.model = model
    }

    let model: FavoriteMealsListModel

    public var body: some View {
        NavigationStack {
            List(model.favorites) { meal in
                MealsListRowView(meal: meal,
                                 isFavorite: model.isFavorite(meal),
                                 onFavoriteButtonTapped: { model.onFavoriteButtonTapped(meal) })
            }
            .navigationDestination(for: Meal.self) { meal in
                MealDetailsView(model: MealDetailsModel(meal: meal,
                                                        apiClient: .live))
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoriteMealsListView(model: FavoriteMealsListModel(repo: MealsRepoTest()))
}
