//
//  CategoryListView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/15/24.
//

import MealsApi
import MealsList
import MealsUI
import SDWebImageSwiftUI
import SwiftUI

public struct CategoryListView: View {
    public init(model: CategoryListModel) {
        self.model = model
    }
    
    let model: CategoryListModel
    
    public var body: some View {
        NavigationStack {
            Group {
                if model.isLoading {
                    ListLoadingView()
                } else if let error = model.error {
                    ErrorView(errorMessage: error,
                              onRetryButtonTapped: model.onRetryButtonTapped)
                } else {
                    List {
                        ForEach(model.categories) { category in
                            NavigationLink(value: category) {
                                HStack {
                                    Text(category.name)
                                    Spacer()
                                    thumbnailImage(category: category)
                                        .padding(.leading)
                                }
                                .padding()
                            }
                        }
                    }
                    .navigationDestination(for: MealCategory.self) { category in
                        MealsListView(model: MealsListModel(category: category,
                                                            apiClient: .live))
                    }
                }
            }
            .navigationTitle("Meals")
        }
        .tint(Color.primary)
    }
    
    func thumbnailImage(category: MealCategory) -> some View {
        WebImage(url: category.imageURL) { image in
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
    CategoryListView(model: CategoryListModel(apiClient: .test))
}
