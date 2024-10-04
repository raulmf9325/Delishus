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
struct FeastlyApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}

struct AppView: View {
    enum Tab {
        case home
        case favorites
    }
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            MealCategoryListView(model: MealCategoryListModel(apiClient: .live,
                                                              mealsRepo: MealsRepoLive.shared),
                                 onFavoriteButtonTapped: onFavoriteButtonTapped)
            .tag(Tab.home)

            FavoriteMealsListView(model: FavoriteMealsListModel(repo: MealsRepoLive.shared),
                                  onFavoriteButtonTapped: onFavoriteButtonTapped)
                .tag(Tab.favorites)
        }
    }

    private func onFavoriteButtonTapped() {
        switch selectedTab {
        case .home:
            selectedTab = .favorites
        case .favorites:
            selectedTab = .home
        }
    }
}

#Preview {
    AppView()
}
