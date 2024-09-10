//
//  ErrorView.swift
//
//
//  Created by Raul Mena on 9/9/24.
//

import SwiftUI

public struct ErrorView: View {
    public init(errorMessage: String, onRetryButtonTapped: @escaping () -> Void) {
        self.errorMessage = errorMessage
        self.onRetryButtonTapped = onRetryButtonTapped
    }
    
    let errorMessage: String
    let onRetryButtonTapped: () -> Void

    public var body: some View {
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
    ErrorView(errorMessage: "Server error",
              onRetryButtonTapped: {})
}
