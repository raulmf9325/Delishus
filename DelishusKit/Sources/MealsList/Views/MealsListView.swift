//
//  MealsListView.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import Foundation
import MealsApi
import MealsRepo
import MealsUI
import SDWebImageSwiftUI
import SwiftUI

public struct MealsListView: View {
    public init(model: MealsListModel, onFavoriteButtonTapped: @escaping () -> Void) {
        self.model = model
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
    }

    let model: MealsListModel
    let onFavoriteButtonTapped: () -> Void

    public var body: some View {
            Group {
                switch model.state {
                case .loading:
                    ListLoadingView()
                    
                case .loaded:
                    ListView(model: model)
                    
                case let .error(error, _):
                    ListView(model: model, error: error)
                }
            }
            .navigationTitle(model.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onFavoriteButtonTapped) {
                        Image(systemName: "heart.fill")
                    }
                }
            }
    }
}

#Preview {
    MealsListView(model: MealsListModel(listBy: .category([MealCategory].mock[0]),
                                        apiClient: .test,
                                        mealsRepo: MealsRepoTest()),
                  onFavoriteButtonTapped: {})
}
