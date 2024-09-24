//
//  CategoryListView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/15/24.
//


import MealsUI
import SDWebImageSwiftUI
import SwiftUI

public struct MealCategoryListView: View {
    public init(model: MealCategoryListModel) {
        self.model = model
    }
    
    @Bindable var model: MealCategoryListModel
    @Namespace private var namespace
    
    public var body: some View {
        NavigationStack {
            Group {
                switch model.state {
                case .loading:
                    ListLoadingView()
                case let .loaded(categories):
                    ListView(categories: categories, model: model, namespace: namespace)
                case let .searching(searchResult, _, loading):
                    EditingView(searchResult: searchResult,
                                loading: loading,
                                model: model,
                                namespace: namespace)
                case let .error(error):
                    ErrorView(errorMessage: error, onRetryButtonTapped: model.onRetryButtonTapped)
                }
            }
            .navigationTitle("Meals")
        }
        .tint(Color.primary)
    }
}


#Preview {
    MealCategoryListView(model: MealCategoryListModel(apiClient: .test))
}
