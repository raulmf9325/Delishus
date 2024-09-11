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

    @Published var searchFieldText = "" {
        didSet {
            debounceSearchText()
        }
    }

    var filteredDesserts: [Meal] {
        desserts.filter {
            query.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(query)
        }
    }
    
    @Published private var query = ""
    private let apiClient: MealsApi
    private var debounceTask: Task<Void, Error>?

    func onRetryButtonTapped() {
        getDesserts()
    }

    private func getDesserts() {
        error = nil
        isLoading = true

        Task { @MainActor in
            do {
                self.desserts = try await apiClient
                    .getDesserts()
                    .sorted(by: { $0.name < $1.name })
                isLoading = false
            } catch {
                isLoading = false
                self.error = error.localizedDescription
            }
        }
    }

    private func debounceSearchText() {
        debounceTask?.cancel()

        debounceTask = Task(priority: .userInitiated) {
            try await ContinuousClock().sleep(for: .milliseconds(500))
            if !Task.isCancelled {
                await MainActor.run {
                    query = self.searchFieldText
                }
            }
        }
    }
}
