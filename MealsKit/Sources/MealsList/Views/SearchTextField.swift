//
//  SearchTextField.swift
//
//
//  Created by Raul Mena on 9/10/24.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var searchText: String
    let placeholderText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(.gray)

            TextField("", text: $searchText,
                      prompt: Text(placeholderText))
                .font(.body)
                .cornerRadius(8)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .cornerRadius(4)
        .onAppear {

        }
    }
}

#Preview {
    SearchTextField(searchText: .constant(""),
                    placeholderText: "Search dessert")
}
