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
                        ScrollView {
                            Section {
                                LazyVStack {
                                    ForEach(model.categories) { category in
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
                                    .fill(Color(.secondarySystemBackground))
                            )
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 30)
                        .ignoresSafeArea(edges: [.bottom])
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
}


#Preview {
    CategoryListView(model: CategoryListModel(apiClient: .test))
}
