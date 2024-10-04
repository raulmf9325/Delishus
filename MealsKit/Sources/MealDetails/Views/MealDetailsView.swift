//
//  MealDetailsView.swift
//
//
//  Created by Raul Mena on 9/9/24.
//

import MealsApi
import MealsUI
import SDWebImageSwiftUI
import SwiftUI

public struct MealDetailsView: View {
    public init(model: MealDetailsModel) {
        self.model = model
    }
    
    @Bindable var model: MealDetailsModel
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        switch model.state {
        case .loading:
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .frame(height: 250)
                        .foregroundStyle(.gray)
                    VStack(alignment: .leading, spacing: 20) {
                        placeholderText
                        placeholderText
                        placeholderText
                        placeholderText
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            }
            .ignoresSafeArea()
            
        case let .loaded(mealDetails):
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    PosterImageView(imageURlString: mealDetails.thumbnailImageURL ?? "")

                    VStack(alignment: .leading, spacing: 20) {
                        Text(mealDetails.name)
                            .font(.title2)
                            .bold()
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ingredients")
                                .font(.title3)
                                .bold()
                                .underline()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(mealDetails.ingredientAmounts.sorted(by: <), id: \.key) { ingredient, amount in
                                    HStack {
                                        Text("\(ingredient):")
                                            .bold()
                                        Text(amount)
                                    }
                                    .font(.callout)
                                }
                            }
                        }
                        
                        Button(action: { model.onWatchOnYouTubeButtonTapped() }) {
                            HStack {
                                Image(systemName: "play.circle")
                                    .foregroundStyle(.red)
                                    .font(.title2)
                                
                                Text("Watch on YouTube")
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Instructions")
                                .font(.title3)
                                .bold()
                                .underline()
                            Text(mealDetails.instructions)
                                .font(.callout)
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            }
            .ignoresSafeArea()
            .sheet(item: $model.sheet) { sheet in
                switch sheet {
                case let .webView(stringURL):
                    WatchOnYouTubeView(stringURL: stringURL)
                }
            }
            
        case let .error(error):
            ErrorView(errorMessage: error, onRetryButtonTapped: model.onRetryButtonTapped)
        }
    }
    
    var placeholderText: some View {
        Text("""
            Lorem ipsum dolor sit amet, consectetur adipiscing elit\nLorem ipsum dolor sit amet, consectetur adipiscing elit
            """)
        .redacted(reason: .placeholder)
    }
}

struct PosterImageView: View {
    let imageURlString: String

    var body: some View {
        GeometryReader { geometry in
            WebImage(url: URL(string: imageURlString)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "photo.fill")
                    .font(.system(size: 60))
            }
            .frame(width: StretchyHeaderGeometry.getWidth(geometry), height: StretchyHeaderGeometry.getHeight(geometry))
            .clipped()
            .offset(x: StretchyHeaderGeometry.getXOffset(geometry), y: StretchyHeaderGeometry.getYOffset(geometry))
        }
        .frame(height: 250)
    }
}

#Preview {
    NavigationStack {
        MealDetailsView(model: MealDetailsModel(meal: .mock,
                                                apiClient: .test))
    }
}
