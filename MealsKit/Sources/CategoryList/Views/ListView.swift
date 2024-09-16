//
//  ListView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/16/24.
//

import MealsApi
import MealsList
import MealsUI
import SwiftUI

struct ListView: View {
    @Bindable var model: CategoryListModel
    let namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            Section {
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
                        model.isEditing.toggle()
                    }
                }
                
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
            MealsListView(model: MealsListModel(listBy: .category(category),
                                                apiClient: .live))
        }
    }
}

#Preview {
    ListView(model: CategoryListModel(apiClient: .test),
                namespace: Namespace().wrappedValue)
}
