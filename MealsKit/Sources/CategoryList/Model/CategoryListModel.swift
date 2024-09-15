//
//  CategoryListModel.swift
//  MealsKit
//
//  Created by Raul Mena on 9/15/24.
//

import MealsApi
import SwiftUI

@MainActor
@Observable
public class CategoryListModel {
    public init(apiClient: MealsApi) {
        self.apiClient = apiClient
        getCategories()
    }
    
    var categories = [MealCategory]()
    
    private let apiClient: MealsApi
    private(set) var isLoading = false
    private(set) var error: String?
    
    private func getCategories() {
        error = nil
        isLoading = true

        Task { @MainActor in
            do {
                self.categories = try await apiClient
                    .getCategories()
                isLoading = false
            } catch {
                isLoading = false
                self.error = error.localizedDescription
            }
        }
    }
    
    func onRetryButtonTapped() {
        getCategories()
    }
}
