//
//  MealsListRowView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/30/24.
//

import MealsApi
import SwiftUI

public struct MealsListRowView: View {
    public init(meal: Meal, isFavorite: Bool, onFavoriteButtonTapped: @escaping () -> Void) {
        self.meal = meal
        self.isFavorite = isFavorite
        self.onFavoriteButtonTapped = onFavoriteButtonTapped
    }

    let meal: Meal
    let isFavorite: Bool
    let onFavoriteButtonTapped: () -> Void

    public var body: some View {
        NavigationLink(value: meal) {
            HStack {
                Text(meal.name)
                Spacer()
                ThumbnalImageView(url: meal.imageURL)
                    .padding(.leading)
            }
            .padding()
            .swipeActions {
                Button(action: onFavoriteButtonTapped) {
                    Image(systemName: isFavorite ? "heart" : "heart.fill")
                }
                .tint(isFavorite ? Color.red : Color.green)
            }
        }
    }
}

#Preview {
    MealsListRowView(meal: .mock,
                     isFavorite: true,
                     onFavoriteButtonTapped: {})
}
