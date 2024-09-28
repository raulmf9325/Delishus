//
//  MealsListModel.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import MealsApi
import MealsRepo
import Foundation
import SwiftUI

public enum MealsListBy {
    case category(MealCategory)
    case searchResult([Meal])
}

@MainActor
@Observable
public class MealsListModel {
    public init(listBy: MealsListBy,
                apiClient: MealsApi,
                mealsRepo: MealsRepo
    ) {
        self.apiClient = apiClient
        self.mealsRepo = mealsRepo
        self.listBy = listBy
    }
    
    let listBy: MealsListBy
    
    enum State {
        case loading
        case loaded([Meal])
        case error(String, [Meal])
    }
    var state: State = .loading
    
    enum SortBy {
        case alphabeticallyAscending
        case alphabeticallyDescending
    }
    var sortBy: SortBy = .alphabeticallyAscending
    
    var searchFieldText = "" {
        didSet {
            debounceSearchText()
        }
    }
    
    var filteredMeals: [Meal] {
        let meals: [Meal]

        switch state {
        case .loading:
            return []
        case .loaded(let loadedMeals):
            meals = loadedMeals
        case .error(_, let persistedMeals):
            meals = persistedMeals
        }

        return meals
            .filter { query.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(query) }
            .sorted {
                switch sortBy {
                case .alphabeticallyAscending:
                    return $0.name < $1.name
                case .alphabeticallyDescending:
                    return $0.name > $1.name
                }
            }
    }
    
    var searchTextFieldHidden: Bool {
        switch listBy {
        case .category:
            return false
        case .searchResult:
            return true
        }
    }
    
    var navigationTitle: String {
        switch listBy {
        case .category(let mealCategory):
            return mealCategory.name
        case .searchResult:
            return "Meals"
        }
    }
    
    private var query = ""
    private let apiClient: MealsApi
    private let mealsRepo: MealsRepo
    private var debounceTask: Task<Void, Error>?

    func onViewAppeared() {
        switch listBy {
        case .category(let mealCategory):
            getMeals(category: mealCategory)
        case .searchResult(let meals):
            self.state = .loaded(meals)
        }
    }

    func onRetryButtonTapped() {
        guard case let .category(category) = listBy else { return }
        getMeals(category: category)
    }

    private func getMeals(category: MealCategory) {
        state = .loading

        Task {
            do {
                let meals = try await apiClient.getMeals(category.name)
                self.state = .loaded(meals)
                await saveMeals(category: category, meals: meals)
            } catch {
                let persistedMeals = await fetchMeals(category.name)
                self.state = .error(error.localizedDescription, persistedMeals)
            }
        }
    }

    private func fetchMeals(_ categoryName: String) async -> [Meal] {
        do {
            return try await mealsRepo.fetchMeals(categoryName)
        } catch {
            print("Error fetching meals: \(error.localizedDescription)")
            return []
        }
    }

    private func saveMeals(category: MealCategory, meals: [Meal]) async {
        do {
            let updatedMeals = meals.map { Meal(id: $0.id, name: $0.name, categoryName: category.name, thumbnailImageURL: $0.thumbnailImageURL) }
            try await mealsRepo.saveMeals(updatedMeals)
        } catch {
            print("Error persisting meals: \(error.localizedDescription)")
        }
    }

    private func debounceSearchText() {
        debounceTask?.cancel()

        debounceTask = Task(priority: .userInitiated) {
            try await ContinuousClock().sleep(for: .milliseconds(500))
            if !Task.isCancelled {
                await MainActor.run {
                    withAnimation {
                        query = self.searchFieldText
                    }
                }
            }
        }
    }
}
