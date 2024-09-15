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
    private(set) var isLoading = false
    private(set) var error: String?
    
    private let apiClient: MealsApi
    private var expandedCategories: Set<MealCategory> = []
    
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
    
    func isExpanded(_ category: MealCategory) -> Bool {
        expandedCategories.contains(category)
    }
    
    func onExpandCategoryButtonTapped(_ category: MealCategory) {
        if expandedCategories.contains(category) {
            expandedCategories.remove(category)
        } else {
            expandedCategories.insert(category)
        }
    }
    
    func onRetryButtonTapped() {
        getCategories()
    }
}
