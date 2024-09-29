//
//  ListView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/26/24.
//

import MealsApi
import MealsApiLive
import MealDetails
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
                NavigationLink(value: meal) {
                    HStack {
                        Text(meal.name)
                        Spacer()
                        ThumbnalImageView(url: meal.imageURL)
                            .padding(.leading)
                    }
                    .padding()
                    .swipeActions {
                        Button(action: { model.onFavoriteButtonTapped(meal) }) {
                            Image(systemName: meal.isFavorite ? "heart" : "heart.fill")
                        }
                        .tint(meal.isFavorite ? Color.red : Color.green)
                    }
                }
            }
        }
        .navigationDestination(for: Meal.self) { meal in
            MealDetailsView(model: MealDetailsModel(meal: meal,
                                                    apiClient: .live))
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
                                   mealsRepo: .test))
}
