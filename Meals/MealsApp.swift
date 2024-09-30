//
//  mealsApp.swift
//  meals
//
//  Created by Raul Mena on 9/8/24.
//

import MealsApi
import MealsApiLive
import MealCategoryList
import MealsRepo
import MealsRepoLive
import SwiftUI

@main
struct MealsApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                MealCategoryListView(model: MealCategoryListModel(apiClient: .live,
                                                                  mealsRepo: MealsRepoLive.shared))
                    .tag(0)
                    .tabItem {
                        Image(systemName: "house.fill")
                    }

                FavoriteMealsList(repo: MealsRepoLive.shared)
                    .tag(1)
                    .tabItem {
                        Image(systemName: "heart.fill")
                    }
            }
        }
    }
}

struct FavoriteMealsList: View {
    let repo: MealsRepo
    @State private var favorites: [Meal] = []

    var body: some View {
        List(favorites) {
            Text($0.name)
        }
        .task {
            do {
                let allMeals = try await repo.fetchAllMeals()
                self.favorites = allMeals.filter { repo.favoriteMealsIds.contains($0.id) }
            } catch {

            }
        }
    }

}

#Preview {
    MealCategoryListView(model: MealCategoryListModel(apiClient: .test, mealsRepo: MealsRepoTest()))
}
