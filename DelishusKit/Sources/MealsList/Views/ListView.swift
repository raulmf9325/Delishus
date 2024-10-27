//
//  ListView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/26/24.
//

import MealsApi
import MealsApiLive
import MealDetails
import MealsRepo
import MealsRepoLive
import MealsUI
import SwiftUI

struct ListView: View {
    @Bindable var model: MealsListModel
    var error: String?

    var body: some View {
        List {
            if let error {
                ErrorButton(error: error, onRetryButtonTapped: model.onRetryButtonTapped)
            }

            if !model.searchTextFieldHidden {
                HStack {
                    SearchTextField(searchText: $model.searchFieldText, placeholderText: "Search meal")
                    filtersMenu
                }
            }

            ForEach(model.filteredMeals) { meal in
                MealsListRowView(meal: meal,
                                 isFavorite: model.isFavorite(meal),
                                 onFavoriteButtonTapped: { model.onFavoriteButtonTapped(meal) })
            }
        }
        .navigationDestination(for: Meal.self) { meal in
            MealDetailsView(model: MealDetailsModel(meal: meal,
                                                    apiClient: .live,
                                                    mealsRepo: MealsRepoLive.shared))
        }
    }

    var filtersMenu: some View {
        Menu {
            Menu {
                Button(action: { model.sortBy = .alphabeticallyAscending }) {
                    HStack {
                        Text("A - Z")
                        if model.sortBy == .alphabeticallyAscending {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: { model.sortBy = .alphabeticallyDescending }) {
                    HStack {
                        Text("Z - A")
                        if model.sortBy == .alphabeticallyDescending {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                Text("Sort By")
            }
            .buttonStyle(.plain)
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .font(.title2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ListView(model: MealsListModel(listBy: .category([MealCategory].mock[0]),
                                   apiClient: .test,
                                   mealsRepo: MealsRepoTest()))
}
