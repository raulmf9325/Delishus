//
//  MealsRepo.swift
//  MealsKit
//
//  Created by Raul Mena on 9/23/24.
//

import Foundation
import MealsApi

public enum MealsRepoError: Error {
    case notFound
}

public struct MealsRepo {
    public init(fetchAllMealCategories: @escaping () async throws -> [MealCategory],
                saveMealCategories: @escaping ([MealCategory]) async throws -> Void,
                fetchMeals: @escaping (String) async throws -> [Meal],
                saveMeals: @escaping ([Meal]) async throws -> Void,
                fetchAllMeals: @escaping () async throws -> [Meal]) {
        self.fetchAllMealCategories = fetchAllMealCategories
        self.saveMealCategories = saveMealCategories
        self.fetchMeals = fetchMeals
        self.saveMeals = saveMeals
        self.fetchAllMeals = fetchAllMeals
    }
    
    public var fetchAllMealCategories: () async throws -> [MealCategory]
    public var saveMealCategories: ([MealCategory]) async throws -> Void
    public var fetchMeals: (String) async throws -> [Meal]
    public var saveMeals: ([Meal]) async throws -> Void
    public var fetchAllMeals: () async throws -> [Meal]
}

public extension MealsRepo {
    static let test = MealsRepo(fetchAllMealCategories: { [MealCategory].mock },
                                saveMealCategories: { _ in },
                                fetchMeals: { _ in [Meal].mock },
                                saveMeals: { _ in },
                                fetchAllMeals: { [Meal].mock })
}
