//
//  CategoryListView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/15/24.
//

import MealsRepo
import MealsUI
import SDWebImageSwiftUI
import SwiftUI

public struct MealCategoryListView: View {
    public init(model: MealCategoryListModel, onFavoriteButtonTapped: @escaping () -> Void) {
        self.model = model
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
    }
    
    @Bindable var model: MealCategoryListModel
    let onFavoriteButtonTapped: () -> Void
    @Namespace private var namespace
    
    public var body: some View {
        NavigationStack {
            Group {
                switch model.state {
                case .loading:
                    ListLoadingView()
                case let .loaded(categories):
                    ListView(categories: categories, model: model,
                             onFavoriteButtonTapped: onFavoriteButtonTapped, namespace: namespace)
                case let .searching(searchResult, _, loading):
                    EditingView(searchResult: searchResult,
                                loading: loading,
                                model: model,
                                onFavoriteButtonTapped: onFavoriteButtonTapped,
                                namespace: namespace)
                case let .error(error, persistedCategories):
                    ListView(categories: persistedCategories, model: model,
                             onFavoriteButtonTapped: onFavoriteButtonTapped,
                             namespace: namespace,
                             error: error)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onFavoriteButtonTapped) {
                        Image(systemName: "heart.fill")
                    }
                }
            }
            .navigationTitle("Meals")
        }
        .tint(Color.primary)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            model.onViewAppeared()
        }
    }
}

#Preview {
    MealCategoryListView(model: MealCategoryListModel(apiClient: .test,
                                                      mealsRepo: MealsRepoTest()),
                         onFavoriteButtonTapped: {})
}
