//
//  mealsApp.swift
//  meals
//
//  Created by Raul Mena on 9/8/24.
//

import FavoriteMealsList
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

                FavoriteMealsListView(model: FavoriteMealsListModel(repo: MealsRepoLive.shared))
                    .tag(1)
                    .tabItem {
                        Image(systemName: "heart.fill")
                    }
            }
        }
    }
}

#Preview {
    MealCategoryListView(model: MealCategoryListModel(apiClient: .test, mealsRepo: MealsRepoTest()))
}
