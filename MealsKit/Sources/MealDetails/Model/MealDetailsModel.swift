//
//  MealDetailsModel.swift
//
//
//  Created by Raul Mena on 9/9/24.
//

import Foundation
import MealsApi
import SwiftUI

@MainActor
public class MealDetailsModel: ObservableObject {
    public init(meal: Meal, apiClient: MealsApi) {
        self.meal = meal
        self.apiClient = apiClient
        getDetails()
    }

    @Published var mealDetails: MealDetails?
    @Published var isLoading = false
    @Published var error: String?

    enum Sheet: Identifiable {
        case webView(String)

        var id: String {
            switch self {
            case let .webView(stringURL):
                return stringURL
            }
        }
    }
    
    @Published var sheet: Sheet?

    private let meal: Meal
    private let apiClient: MealsApi

    func onWatchOnYouTubeButtonTapped() {
        guard let stringURL = mealDetails?.youtubeURL else { return }
        sheet = .webView(stringURL)
    }

    func onRetryButtonTapped() {
        getDetails()
    }

    private func getDetails() {
        error = nil
        isLoading = true

        Task { @MainActor in
            do {
                let clock = ContinuousClock()
                var details: MealDetails?
                
                let duration = try await clock.measure {
                    details = try await apiClient.getDetails(meal.id)
                }

                if duration < .milliseconds(100) {
                    self.mealDetails = details
                } else {
                    try await clock.sleep(for: .milliseconds(300))
                    self.mealDetails = details
                }
                
                isLoading = false
            } catch {
                isLoading = false
                self.error = error.localizedDescription
            }
        }
    }
}
