//
//  MealsRepo.swift
//  MealsKit
//
//  Created by Raul Mena on 9/23/24.
//

import Foundation
import MealsApi

public struct MealsRepo {
    public init(fetchMealCategories: @escaping () throws -> [MealCategory],
                saveMealCategories: @escaping ([MealCategory]) throws -> Void,
                fetchMeals: @escaping () throws -> [Meal],
                saveMeals: @escaping ([Meal]) throws -> Void) {
        self.fetchMealCategories = fetchMealCategories
        self.saveMealCategories = saveMealCategories
        self.fetchMeals = fetchMeals
        self.saveMeals = saveMeals
    }
    
    public var fetchMealCategories: () throws -> [MealCategory]
    public var saveMealCategories: ([MealCategory]) throws -> Void
    public var fetchMeals: () throws -> [Meal]
    public var saveMeals: ([Meal]) throws -> Void
}

public extension MealsRepo {
    static let test = MealsRepo(fetchMealCategories: { [MealCategory].mock },
                                saveMealCategories: { _ in },
                                fetchMeals: { [Meal].mock },
                                saveMeals: { _ in })
}
