//
//  MealsListErrorView.swift
//
//
//  Created by Raul Mena on 9/8/24.
//

import SwiftUI

struct MealsListErrorView: View {
    let errorMessage: String
    let onRetryButtonTapped: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.red)
                .padding(.bottom, 10)
            VStack(spacing: 10) {
                Text("An error occurred")
                Text(errorMessage)
                Button(action: onRetryButtonTapped) {
                    HStack {
                        Text("Retry")
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue))
                }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    MealsListErrorView(errorMessage: "Server error", 
                       onRetryButtonTapped: {})
}
