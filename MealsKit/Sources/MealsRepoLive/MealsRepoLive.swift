//
//  MealsRepoLive.swift
//  MealsKit
//
//  Created by Raul Mena on 9/23/24.
//

import Foundation
import MealsApi
import MealsRepo
import SwiftData

public extension MealsRepo {
    static let live: MealsRepo = {
        let repo = MealsRepoLive()
        return MealsRepo(fetchAllMealCategories: { try repo.fetchAllMealCategories() },
                         saveMealCategories: { try repo.saveMealCategories($0) },
                         fetchMeals: { try repo.fetchMeals(categoryName: $0) },
                         saveMeals: { try repo.saveMeals($0) },
                         fetchAllMeals: { try repo.fetchAllMeals() })
    }()
}

@ModelActor
actor MealsRepoLive {
    init() {
        let container = try! ModelContainer(for: MealModel.self, MealCategoryModel.self)
        let modelContext = ModelContext(container)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = container
    }

    private var context: ModelContext { modelExecutor.modelContext }

    func fetchAllMealCategories() throws -> [MealCategory] {
        try context.fetch(FetchDescriptor<MealCategoryModel>()).map(\.mealCategory)
    }

    func saveMealCategories(_ categories: [MealCategory]) throws {
        let models = categories.map(MealCategoryModel.init)

        models.forEach {
            context.insert($0)
        }

        try context.save()
    }

    func fetchMeals(categoryName: String) throws -> [Meal] {
        let mealsWithCategory = #Predicate<MealModel> { meal in
            meal.categoryName == categoryName
        }

        return try context.fetch(FetchDescriptor<MealModel>(predicate: mealsWithCategory)).map(\.meal)
    }

    func fetchAllMeals() throws -> [Meal] {
        try context.fetch(FetchDescriptor<MealModel>()).map(\.meal)
    }

    func saveMeals(_ meals: [Meal]) throws {
        let models = meals.map(MealModel.init)

        models.forEach {
            context.insert($0)
        }

        try context.save()
    }
}

