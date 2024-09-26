//
//  MealsRepo.swift
//  MealsKit
//
//  Created by Raul Mena on 9/23/24.
//

import Foundation
import MealsApi

public struct MealsRepo {
    public init(fetchMealCategories: @escaping () async throws -> [MealCategory],
                saveMealCategories: @escaping ([MealCategory]) async throws -> Void,
                fetchMeals: @escaping () async throws -> [Meal],
                saveMeals: @escaping ([Meal]) async throws -> Void) {
        self.fetchMealCategories = fetchMealCategories
        self.saveMealCategories = saveMealCategories
        self.fetchMeals = fetchMeals
        self.saveMeals = saveMeals
    }
    
    public var fetchMealCategories: () async throws -> [MealCategory]
    public var saveMealCategories: ([MealCategory]) async throws -> Void
    public var fetchMeals: () async throws -> [Meal]
    public var saveMeals: ([Meal]) async throws -> Void
}

public extension MealsRepo {
    static let test = MealsRepo(fetchMealCategories: { [MealCategory].mock },
                                saveMealCategories: { _ in },
                                fetchMeals: { [Meal].mock },
                                saveMeals: { _ in })
}
