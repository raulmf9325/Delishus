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

    @ObservedObject var model: MealsListModel

    public var body: some View {
        NavigationStack {
            Group {
                if model.isLoading {
                    MealsListLoadingView()
                } else if let error = model.error {
                    ErrorView(errorMessage: error,
                              onRetryButtonTapped: model.onRetryButtonTapped)
                } else {
                    List {
                        SearchTextField(searchText: $model.searchFieldText, placeholderText: "Search dessert")

                        ForEach(model.filteredDesserts) { meal in
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
            .navigationTitle("Desserts")
        }
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
    MealsListView(model: MealsListModel(apiClient: .test))
}
