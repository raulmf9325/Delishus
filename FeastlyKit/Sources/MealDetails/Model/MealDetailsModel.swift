//
//  MealDetailsModel.swift
//
//
//  Created by Raul Mena on 9/9/24.
//

import Foundation
import MealsApi
import MealsRepo
import SwiftUI

@MainActor
@Observable
public class MealDetailsModel {
    public init(meal: Meal, apiClient: MealsApi, mealsRepo: MealsRepo) {
        self.meal = meal
        self.apiClient = apiClient
        self.mealsRepo = mealsRepo
        getDetails()
    }

    enum State {
        case loading
        case loaded(MealDetails)
        case error(String)
    }
    var state: State = .loading
    
    enum Sheet: Identifiable {
        case webView(String)

        var id: String {
            switch self {
            case let .webView(stringURL):
                return stringURL
            }
        }
    }
    
    var sheet: Sheet?

    private let meal: Meal
    private let apiClient: MealsApi
    private let mealsRepo: MealsRepo

    func onWatchOnYouTubeButtonTapped() {
        guard case .loaded(let mealDetails) = state, let url = mealDetails.youtubeURL else { return }
        sheet = .webView(url)
    }

    func onRetryButtonTapped() {
        getDetails()
    }

    func isFavorite() -> Bool {
        mealsRepo.favoriteMealsIds.contains(meal.id)
    }

    func onFavoriteButtonTapped() {
        Task {
            if mealsRepo.favoriteMealsIds.contains(meal.id) {
                try await mealsRepo.removeFavoriteMeals(ids: [meal.id])
            } else {
                try await mealsRepo.saveFavoriteMeals(ids: [meal.id])
            }
        }
    }

    private func getDetails() {
        state = .loading

        Task { @MainActor in
            do {
                let clock = ContinuousClock()
                var details: MealDetails?
                
                let duration = try await clock.measure {
                    details = try await apiClient.getDetails(meal.id)
                }

                if let details {
                    if duration < .milliseconds(100) {
                        self.state = .loaded(details)
                    } else {
                        try await clock.sleep(for: .milliseconds(300))
                        self.state = .loaded(details)
                    }
                }
            } catch {
                self.state = .error(error.localizedDescription)
            }
        }
    }
}
