//
//  MealsListLoadingView.swift
//
//
//  Created by Raul Mena on 9/8/24.
//

import SwiftUI

struct MealsListLoadingView: View {
    var body: some View {
        VStack {
            ForEach(0..<3) { _ in
                HStack(spacing: 30) {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
                        .redacted(reason: .placeholder)

                    Spacer()
                    Image(systemName: "photo.fill")
                        .font(.system(size: 90))
                        .redacted(reason: .placeholder)
                }
                .padding()
            }

            Spacer()
        }
    }
}

#Preview {
    MealsListLoadingView()
}
