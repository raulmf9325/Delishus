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
        return MealsRepo(fetchMealCategories: { try repo.fetchMealCategories() },
                         saveMealCategories: { try repo.saveMealCategories($0) },
                         fetchMeals: { try repo.fetchMeals() },
                         saveMeals: { try repo.saveMeals($0) })
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

    func fetchMealCategories() throws -> [MealCategory] {
        try context.fetch(FetchDescriptor<MealCategoryModel>()).map(\.mealCategory)
    }

    func saveMealCategories(_ categories: [MealCategory]) throws {
        let models = categories.map(MealCategoryModel.init)

        models.forEach {
            context.insert($0)
        }

        try context.save()
    }

    func fetchMeals() throws -> [Meal] {
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

