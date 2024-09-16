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
    var isEditing = false
    var mealsSearchResult = [Meal]()
    private(set) var isLoading = false
    private(set) var error: String?
    
    private var oldSearchFieldText = ""
    var searchFieldText = "" {
        willSet {
            oldSearchFieldText = searchFieldText
        }
        didSet {
            debounceSearchText()
        }
    }
    
    private let apiClient: MealsApi
    private var expandedCategories: Set<MealCategory> = []
    private var debounceTask: Task<Void, Error>?
        
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
    
    func onCancelSearchButtonTapped() {
        searchFieldText = ""
        withAnimation {
            isEditing = false
        }
    }
    
    func onRetryButtonTapped() {
        getCategories()
    }
    
    private func getCategories() {
        error = nil
        isLoading = true

        Task { @MainActor in
            do {
                self.categories = try await apiClient.getCategories()
                isLoading = false
            } catch {
                isLoading = false
                self.error = error.localizedDescription
            }
        }
    }
    
    private func searchMeal() {
        guard !searchFieldText.isEmpty else {
            self.mealsSearchResult = []
            return
        }
                
        Task { @MainActor in
            do {
                error = nil
                isLoading = true
                var mealDetails: [MealDetails]?
                
                let clock = ContinuousClock()
                let duration = try await clock.measure {
                    mealDetails = try await apiClient.searchMeal(searchFieldText)
                }
                
                if duration < .milliseconds(100) {
                    self.mealsSearchResult = [Meal](from: mealDetails ?? [])
                } else {
                    try await clock.sleep(for: .milliseconds(300))
                    self.mealsSearchResult = [Meal](from: mealDetails ?? [])
                }

                isLoading = false
            } catch {
                isLoading = false
                self.mealsSearchResult = []
            }
        }
    }
    
    private func debounceSearchText() {
        guard oldSearchFieldText != searchFieldText else { return }
        debounceTask?.cancel()

        debounceTask = Task(priority: .userInitiated) {
            try await ContinuousClock().sleep(for: .seconds(1))
            if !Task.isCancelled {
                searchMeal()
            }
        }
    }
}
