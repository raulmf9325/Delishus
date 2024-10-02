//
//  FavoriteMealsListModel.swift
//  MealsKit
//
//  Created by Raul Mena on 9/30/24.
//

import MealsApi
import SwiftUI
import MealsRepo

@MainActor
@Observable
public class FavoriteMealsListModel {
    public init(repo: MealsRepo) {
        self.repo = repo

        Task {
            try await refreshFavorites()
        }
    }

    // MARK: - Exposed Members
    var favorites: [Meal] {
        meals.sorted { $0.name < $1.name }
    }

    func isFavorite(_ meal: Meal) -> Bool {
        repo.favoriteMealsIds.contains(meal.id)
    }

    func onFavoriteButtonTapped(_ meal: Meal) {
        _ = withAnimation {
            meals.remove(meal)
        }

        Task {
            try await repo.removeFavoriteMeals(ids: [meal.id])
        }
    }

    // MARK: - Private Members
    private let repo: MealsRepo

    private var meals: Set<Meal> = []

    private func refreshFavorites() async throws {
        let allMeals = try await repo.fetchAllMeals()
        self.meals = Set(allMeals.filter { repo.favoriteMealsIds.contains($0.id) })
    }
}
