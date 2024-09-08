//
//  MealsListView.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import Foundation
import SwiftUI

public struct MealsListView: View {
    public init(model: MealsListModel) {
        self.model = model
    }

    @ObservedObject var model: MealsListModel

    public var body: some View {
        List {
            ForEach(model.desserts) { meal in
                HStack {
                    Text(meal.name)
                    Spacer()
                    AsyncImage(url: meal.imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    } placeholder: {
                        Image(systemName: "photo.fill")
                            .frame(width: 100)
                    }

                }
                .padding()
            }
        }
    }
}

#Preview {
    MealsListView(model: MealsListModel(apiClient: .test))
}
