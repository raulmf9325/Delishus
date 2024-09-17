//
//  CategoryListView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/15/24.
//


import MealsUI
import SDWebImageSwiftUI
import SwiftUI

public struct CategoryListView: View {
    public init(model: CategoryListModel) {
        self.model = model
    }
    
    @Bindable var model: CategoryListModel
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
    CategoryListView(model: CategoryListModel(apiClient: .test))
}
