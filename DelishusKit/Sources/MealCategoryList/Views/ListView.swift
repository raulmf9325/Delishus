//
//  ListView.swift
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

struct ListView: View {
    let categories: [MealCategory]
    let model: MealCategoryListModel
    let onFavoriteButtonTapped: () -> Void
    let namespace: Namespace.ID
    var error: String?

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            Section {
                if let error {
                    ErrorButton(error: error, onRetryButtonTapped: model.onRetryButtonTapped)
                } else {
                    SearchMealTextField(model: model, namespace: namespace)
                }

                LazyVStack {
                    ForEach(categories) { category in
                        VStack {
                            HStack {
                                Button(action: {
                                    withAnimation(.linear(duration: 0.2)) {
                                        model.onExpandCategoryButtonTapped(category)
                                    }
                                }) {
                                    Text("+")
                                        .font(.title3)
                                }
                                .padding(.trailing)
                                
                                NavigationLink(value: category) {
                                    HStack {
                                        Text(category.name)
                                        Spacer()
                                        ThumbnalImageView(url: category.imageURL)
                                            .padding(.trailing, 14)
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13))
                                            .bold()
                                            .foregroundStyle(Color(.tertiaryLabel))
                                    }
                                }
                            }
                            .padding()
                            
                            if model.isExpanded(category) {
                                Text(category.description)
                                    .lineLimit(5)
                                    .padding([.horizontal, .bottom])
                            }
                            
                            Divider()
                                .padding([.leading])
                        }
                        .padding([.leading])
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(colorScheme == .light ? Color.white : Color(.secondarySystemBackground))
            )
            .padding(.horizontal)
        }
        .padding(.bottom, 30)
        .ignoresSafeArea(edges: [.bottom])
        .navigationDestination(for: MealCategory.self) { category in
            MealsListView(model: MealsListModel(listBy: .category(category),
                                                apiClient: .live,
                                                mealsRepo: MealsRepoLive.shared),
                          onFavoriteButtonTapped: onFavoriteButtonTapped)
        }
        .background(
            colorScheme == .light ?  RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)).ignoresSafeArea() : nil
        )
    }
}

#Preview {
    ListView(categories: [MealCategory].mock,
             model: MealCategoryListModel(apiClient: .test, mealsRepo: MealsRepoTest()),
             onFavoriteButtonTapped: {},
             namespace: Namespace().wrappedValue)
}

private struct SearchMealTextField: View {
    @Bindable var model: MealCategoryListModel
    let namespace: Namespace.ID

    var body: some View {
        VStack {
            SearchTextField(searchText: $model.searchFieldText,
                            placeholderText: "Search a meal")
            .disabled(true)
            .matchedGeometryEffect(id: "searchTextField", in: namespace)
            Divider()
        }
        .padding(.top)
        .padding(.leading)
        .padding(.leading)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                model.onSearchMealButtonTapped()
            }
        }
    }
}
