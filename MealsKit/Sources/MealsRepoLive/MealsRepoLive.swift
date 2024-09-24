//
//  MealsRepoLive.swift
//  MealsKit
//
//  Created by Raul Mena on 9/23/24.
//

import MealsApi
import MealsRepo
import SwiftData

public extension MealsRepo {
    static let live: MealsRepo = {
        let repo = MealsRepoLive()
        return MealsRepo(fetchMealCategories: repo.fetchMealCategories,
                         saveMealCategories: repo.saveMealCategories,
                         fetchMeals: repo.fetchMeals,
                         saveMeals: repo.saveMeals)
    }()
}

class MealsRepoLive {
    init() {
        let container = try! ModelContainer(for: MealModel.self, MealCategoryModel.self)
        self.context = ModelContext(container)
    }

    private let context: ModelContext

    func fetchMealCategories() throws -> [MealCategory] {
        try context.fetch(FetchDescriptor<MealCategoryModel>()).map(\.mealCategory)
    }

    func saveMealCategories(_ categories: [MealCategory]) throws {
        let models = categories.map(MealCategoryModel.init)

        models.forEach {
            context.insert($0)
        }
    }

    func fetchMeals() throws -> [Meal] {
        try context.fetch(FetchDescriptor<MealModel>()).map(\.meal)
    }

    func saveMeals(_ meals: [Meal]) throws {
        let models = meals.map(MealModel.init)

        models.forEach {
            context.insert($0)
        }
    }
}

