//
//  ThumbnalImageView.swift
//  MealsKit
//
//  Created by Raul Mena on 9/15/24.
//

import SDWebImageSwiftUI
import SwiftUI

public struct ThumbnalImageView: View {
    public init(url: URL?) {
        self.url = url
    }
    
    let url: URL?
    
    public var body: some View {
        WebImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "photo.circle.fill")
                .font(.system(size: 90))
        }
        .frame(width: 100, height: 100)
        .clipShape(Circle())
    }
}

#Preview {
    ThumbnalImageView(url: nil)
}
