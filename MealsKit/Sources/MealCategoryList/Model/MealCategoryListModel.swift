//
//  CategoryListModel.swift
//  MealsKit
//
//  Created by Raul Mena on 9/15/24.
//

import MealsApi
import MealsRepo
import SwiftUI

@MainActor
@Observable
public class MealCategoryListModel {
    public init(apiClient: MealsApi, mealsRepo: MealsRepo) {
        self.apiClient = apiClient
        self.mealsRepo = mealsRepo
    }
    
    enum State {
        case loading
        case loaded(categories: [MealCategory])
        case searching(searchResult: [Meal], categories: [MealCategory], loading: Bool)
        case error(String, [MealCategory])
    }
    var state: State = .loading
    
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
    private let mealsRepo: MealsRepo
    private var expandedCategories: Set<MealCategory> = []
    private var debounceTask: Task<Void, Error>?

    func onViewAppeared() {
        if case .loading = state {
            getCategories()
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
    
    func onSearchMealButtonTapped() {
        guard case let .loaded(categories) = state else { return }
        state = .searching(searchResult: [], categories: categories, loading: false)
    }
    
    func onCancelSearchButtonTapped() {
        guard case let .searching(_, categories, _) = state else { return }
        searchFieldText = ""
        withAnimation {
            state = .loaded(categories: categories)
        }
    }
    
    func onRetryButtonTapped() {
        getCategories()
    }
    
    private func getCategories() {
        state = .loading

        Task { @MainActor in
            do {
                let categories = try await apiClient.getCategories()
                self.state = .loaded(categories: categories)
                await saveCategories(categories)
            } catch {
                let persistedCategories = await fetchCategories()
                self.state = .error(error.localizedDescription, persistedCategories)
            }
        }
    }

    private func fetchCategories() async -> [MealCategory] {
        do {
            return try await mealsRepo.fetchMealCategories()
        } catch {
            print("Error fetching meal categories: \(error.localizedDescription)")
            return []
        }
    }

    private func saveCategories(_ categories: [MealCategory]) async {
        do {
            try await self.mealsRepo.saveMealCategories(categories)
        } catch {
            print("Error persisting meal categories: \(error.localizedDescription)")
        }
    }

    private func searchMeal() {
        guard case let .searching(_, categories, _) = state else { return }
        
        guard !searchFieldText.isEmpty else {
            self.state = .searching(searchResult: [], categories: categories, loading: false)
            return
        }
                
        Task { @MainActor in
            do {
                self.state = .searching(searchResult: [], categories: categories, loading: true)
                var mealDetails: [MealDetails]?
                
                let clock = ContinuousClock()
                let duration = try await clock.measure {
                    mealDetails = try await apiClient.searchMeal(searchFieldText)
                }
                
                if duration < .milliseconds(100) {
                    self.state = .searching(searchResult: [Meal](from: mealDetails ?? []), categories: categories, loading: false)
                } else {
                    try await clock.sleep(for: .milliseconds(300))
                    self.state = .searching(searchResult: [Meal](from: mealDetails ?? []), categories: categories, loading: false)
                }
            } catch {
                self.state = .searching(searchResult: [], categories: categories, loading: false)
            }
        }
    }
    
    private func debounceSearchText() {
        guard oldSearchFieldText != searchFieldText else { return }
        debounceTask?.cancel()

        debounceTask = Task(priority: .userInitiated) {
            try await ContinuousClock().sleep(for: .milliseconds(600))
            if !Task.isCancelled {
                searchMeal()
            }
        }
    }
}
