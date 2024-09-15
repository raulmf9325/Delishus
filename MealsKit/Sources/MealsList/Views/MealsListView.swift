//
//  MealsListView.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import Foundation
import MealsApi
import MealsApiLive
import MealDetails
import MealsUI
import SDWebImageSwiftUI
import SwiftUI

public struct MealsListView: View {
    public init(model: MealsListModel) {
        self.model = model
    }

    @Bindable var model: MealsListModel

    public var body: some View {
            Group {
                if model.isLoading {
                    ListLoadingView()
                } else if let error = model.error {
                    ErrorView(errorMessage: error,
                              onRetryButtonTapped: model.onRetryButtonTapped)
                } else {
                    List {
                        HStack {
                            SearchTextField(searchText: $model.searchFieldText, placeholderText: "Search dessert")
                            filtersMenu
                        }

                        ForEach(model.filteredMeals) { meal in
                            NavigationLink(value: meal) {
                                HStack {
                                    Text(meal.name)
                                    Spacer()
                                    thumbnailImage(meal: meal)
                                        .padding(.leading)
                                }
                                .padding()
                            }
                        }
                    }
                    .navigationDestination(for: Meal.self) { meal in
                        MealDetailsView(model: MealDetailsModel(meal: meal,
                                                                apiClient: .live))
                    }
                }
            }
            .navigationTitle(model.category.name)
    }
    
    var filtersMenu: some View {
        Menu {
            Button(action: { model.sortBy = .alphabeticallyAscending }) {
                Text("Alphabetically: A - Z")
            }
            Button(action: { model.sortBy = .alphabeticallyDescending }) {
                Text("Alphabetically: Z - A")
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .font(.title2)
        }
        .buttonStyle(.plain)
    }

    func thumbnailImage(meal: Meal) -> some View {
        WebImage(url: meal.imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "photo.circle.fill")
                .font(.system(size: 90))
        }
        .frame(width: 100, height: 100)
        .clipShape(Circle())
    }
}

#Preview {
    MealsListView(model: MealsListModel(category: [MealCategory].mock[0],
                                        apiClient: .test))
}
