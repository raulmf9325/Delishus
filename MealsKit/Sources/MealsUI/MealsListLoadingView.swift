//
//  ListLoadingView.swift
//
//
//  Created by Raul Mena on 9/8/24.
//

import SwiftUI

public struct ListLoadingView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            ForEach(0..<3) { _ in
                HStack(spacing: 30) {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
                        .redacted(reason: .placeholder)

                    Spacer()
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .redacted(reason: .placeholder)
                        .clipShape(Circle())
                }
                .padding()
            }

            Spacer()
        }
    }
}

#Preview {
    ListLoadingView()
}
