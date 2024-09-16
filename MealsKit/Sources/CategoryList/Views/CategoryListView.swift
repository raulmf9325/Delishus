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
                if model.isLoading {
                    ListLoadingView()
                } else if let error = model.error {
                    ErrorView(errorMessage: error,
                              onRetryButtonTapped: model.onRetryButtonTapped)
                } else if model.isEditing {
                    EditingView(model: model, namespace: namespace)
                } else {
                    ListView(model: model, namespace: namespace)
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
