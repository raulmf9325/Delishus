//
//  MealsListModel.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import MealsApi
import Foundation
import SwiftUI

public enum MealsListBy {
    case category(MealCategory)
    case searchResult([Meal])
}

@MainActor
@Observable
public class MealsListModel {
    public init(listBy: MealsListBy, apiClient: MealsApi) {
        self.apiClient = apiClient
        self.listBy = listBy
        
        switch listBy {
        case .category(let mealCategory):
            getMeals(category: mealCategory)
        case .searchResult(let meals):
            self.state = .loaded(meals)
        }
    }
    
    let listBy: MealsListBy
    
    enum State {
        case loading
        case loaded([Meal])
        case error(String)
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
        guard case .loaded(let meals) = state else { return [] }
        
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
    private var debounceTask: Task<Void, Error>?

    func onRetryButtonTapped() {
        guard case let .category(category) = listBy else { return }
        getMeals(category: category)
    }

    private func getMeals(category: MealCategory) {
        state = .loading

        Task { @MainActor in
            do {
                self.state = .loaded(try await apiClient.getMeals(category.name))
            } catch {
                self.state = .error(error.localizedDescription)
            }
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
