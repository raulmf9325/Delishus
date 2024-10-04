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

@MainActor
public protocol MealsRepo {
    var favoriteMealsIds: Set<String> { get }
    func fetchAllMealCategories() async throws -> [MealCategory]
    func fetchAllMeals() async throws -> [Meal]
    func fetchMeals(categoryName: String) async throws -> [Meal]
    func saveMealCategories(_ categories: [MealCategory]) async throws
    func saveMeals(_ meals: [Meal]) async throws
    func saveFavoriteMeals(ids: [String]) async throws
    func removeFavoriteMeals(ids: [String]) async throws
}

public struct MealsRepoTest: MealsRepo {
    public init() {}

    public var favoriteMealsIds: Set<String> { [] }

    public func fetchAllMealCategories() async throws -> [MealCategory] {
        [MealCategory].mock
    }
    
    public func fetchAllMeals() async throws -> [Meal] {
        [Meal].mock
    }
    
    public func fetchMeals(categoryName: String) async throws -> [Meal] {
        [Meal].mock
    }
    
    public func saveMealCategories(_ categories: [MealCategory]) async throws {}
    
    public func saveMeals(_ meals: [Meal]) async throws {}

    public func saveFavoriteMeals(ids: [String]) {}
    public func removeFavoriteMeals(ids: [String]) {}
}
