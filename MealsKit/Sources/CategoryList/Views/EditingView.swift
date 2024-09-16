//
//  EditingView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/16/24.
//

import MealsUI
import SwiftUI

struct EditingView: View {
    @Bindable var model: CategoryListModel
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
                
                Button("Cancel") {
                    withAnimation {
                        model.isEditing.toggle()
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

#Preview {
    EditingView(model: CategoryListModel(apiClient: .test),
                namespace: Namespace().wrappedValue)
}
