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
    public init(model: MealsListModel) {
        self.model = model
    }

    let model: MealsListModel

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
            .onAppear {
                model.onViewAppeared()
            }
    }
}

#Preview {
    MealsListView(model: MealsListModel(listBy: .category([MealCategory].mock[0]),
                                        apiClient: .test,
                                        mealsRepo: MealsRepoTest()))
}
