//
//  MealsListModel.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import MealsApi
import Foundation
import SwiftUI

@MainActor
public class MealsListModel: ObservableObject {
    public init(apiClient: MealsApi) {
        self.apiClient = apiClient
        getDesserts()
    }

    @Published var desserts = [Meal]()
    @Published var isLoading = false
    @Published var error: String?

    private let apiClient: MealsApi

    func onRetryButtonTapped() {
        getDesserts()
    }

    private func getDesserts() {
        error = nil
        isLoading = true

        Task { @MainActor in
            do {
                self.desserts = try await apiClient.getDesserts()
                isLoading = false
            } catch {
                isLoading = false
                self.error = error.localizedDescription
            }
        }
    }
}
