//
//  EditingView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/16/24.
//

import MealsApi
import MealsRepo
import MealsRepoLive
import MealsList
import MealsUI
import SwiftUI

struct EditingView: View {
    let searchResult: [Meal]
    let loading: Bool
    @Bindable var model: MealCategoryListModel
    let namespace: Namespace.ID
    
    var body: some View {
        VStack {
            HStack(spacing: 14) {
                SearchTextField(searchText: $model.searchFieldText,
                                placeholderText: "Search a meal")
                .matchedGeometryEffect(id: "searchTextField", in: namespace)
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.secondarySystemBackground))
                )
                
                Button("Cancel", action: model.onCancelSearchButtonTapped) 
            }
            .padding(.horizontal)
            
            if loading {
                ListLoadingView()
            } else {
                MealsListView(model: MealsListModel(listBy: .searchResult(searchResult),
                                                    apiClient: .live,
                                                    mealsRepo: MealsRepoLive.shared))
            }
        }
    }
}

#Preview {
    EditingView(searchResult: [Meal].mock,
                loading: false,
                model: MealCategoryListModel(apiClient: .test, mealsRepo: MealsRepoTest()),
                namespace: Namespace().wrappedValue)
}
