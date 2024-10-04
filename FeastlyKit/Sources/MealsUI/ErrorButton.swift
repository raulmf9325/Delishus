//
//  ErrorButton.swift
//  MealsKit
//
//  Created by Raul Mena on 9/26/24.
//

import SwiftUI

public struct ErrorButton: View {
    public init(error: String, onRetryButtonTapped: @escaping () -> Void) {
        self.error = error
        self.onRetryButtonTapped = onRetryButtonTapped
    }
    
    let error: String
    let onRetryButtonTapped: () -> Void

    public var body: some View {
        VStack(spacing: 15) {
            Text("Oops! Something went wrong")

            Button(action: onRetryButtonTapped) {
                HStack {
                    Text("Retry")
                    Image(systemName: "arrow.counterclockwise")
                }
            }
        }
        .tint(.red)
        .padding(.top)
    }
}
