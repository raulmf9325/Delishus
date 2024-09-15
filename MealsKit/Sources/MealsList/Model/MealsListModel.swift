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
@Observable
public class MealsListModel {
    public init(apiClient: MealsApi) {
        self.apiClient = apiClient
        getDesserts()
    }

    private(set) var desserts = [Meal]()
    private(set) var isLoading = false
    private(set) var error: String?

    var searchFieldText = "" {
        didSet {
            debounceSearchText()
        }
    }

    var filteredDesserts: [Meal] {
        desserts.filter {
            query.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(query)
        }
    }
    
    private var query = ""
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
