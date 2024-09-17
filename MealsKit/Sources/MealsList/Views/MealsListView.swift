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
                switch model.state {
                case .loading:
                    ListLoadingView()
                    
                case .loaded:
                    List {
                        if !model.searchTextFieldHidden {
                            HStack {
                                SearchTextField(searchText: $model.searchFieldText, placeholderText: "Search dessert")
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
                            }
                        }
                    }
                    .navigationDestination(for: Meal.self) { meal in
                        MealDetailsView(model: MealDetailsModel(meal: meal,
                                                                apiClient: .live))
                    }
                    
                case let .error(error):
                    ErrorView(errorMessage: error, onRetryButtonTapped: model.onRetryButtonTapped)
                }
            }
            .navigationTitle(model.navigationTitle)
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
    MealsListView(model: MealsListModel(listBy: .category([MealCategory].mock[0]),
                                        apiClient: .test))
}
