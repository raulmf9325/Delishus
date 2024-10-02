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

@Observable
public class MealsRepoLive: MealsRepo {
    public static let shared = MealsRepoLive()
    
    private init() {
        Task { @MainActor in
            try await fetchFavoriteMeals()
        }
    }
    
    private let storage = MealsStorage()

    public private(set) var favoriteMealsIds: Set<String> = []

    public func fetchAllMealCategories() async throws -> [MealCategory] {
        try await storage.fetchAllMealCategories()
    }
    
    public func fetchAllMeals() async throws -> [Meal] {
        return try await storage.fetchAllMeals()
    }
    
    public func fetchMeals(categoryName: String) async throws -> [Meal] {
        return try await storage.fetchMeals(categoryName: categoryName)
    }
    
    public func saveMealCategories(_ categories: [MealCategory]) async throws {
        try await storage.saveMealCategories(categories)
    }
    
    public func saveMeals(_ meals: [Meal]) async throws {
        try await storage.saveMeals(meals)
    }

    public func saveFavoriteMeals(ids: [String]) async throws {
        favoriteMealsIds.formUnion(ids)

        let favorites = ids.map(FavoriteMealModel.init)
        try await storage.saveFavoriteMeals(favorites)
    }

    public func removeFavoriteMeals(ids: [String]) async throws {
        favoriteMealsIds.subtract(ids)
        try await storage.removeFavoriteMeals(ids: ids)
    }

    func fetchFavoriteMeals() async throws {
        let mealsIds = try await storage.fetchFavoriteMealsIds()
        self.favoriteMealsIds.formUnion(mealsIds)
    }
}

@ModelActor
actor MealsStorage {
    init() {
        let container = try! ModelContainer(for: MealModel.self,
                                            MealCategoryModel.self,
                                            FavoriteMealModel.self)
        let modelContext = ModelContext(container)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = container
    }

    private var context: ModelContext { modelExecutor.modelContext }

    func fetchAllMealCategories() throws -> [MealCategory] {
        let sortByName = SortDescriptor(\MealCategoryModel.name)
        return try context.fetch(FetchDescriptor<MealCategoryModel>(sortBy: [sortByName])).map(\.mealCategory)
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

        let sortByName = SortDescriptor(\MealModel.name)

        return try context.fetch(FetchDescriptor<MealModel>(predicate: mealsWithCategory, sortBy: [sortByName])).map(\.meal)
    }

    func fetchAllMeals() throws -> [Meal] {
        let sortByName = SortDescriptor(\MealModel.name)
        return try context.fetch(FetchDescriptor<MealModel>(sortBy: [sortByName])).map(\.meal)
    }

    func saveMeals(_ meals: [Meal]) throws {
        let models = meals.map(MealModel.init)

        models.forEach {
            context.insert($0)
        }

        try context.save()
    }

    func saveFavoriteMeals(_ models: [FavoriteMealModel]) throws {
        models.forEach {
            context.insert($0)
        }
        try context.save()
    }

    func removeFavoriteMeals(ids: [String]) throws {
        let favoritesWithIds = #Predicate<FavoriteMealModel> { favorite in
            ids.contains(favorite.id)
        }
        let models = try context.fetch(FetchDescriptor<FavoriteMealModel>(predicate: favoritesWithIds))
        models.forEach {
            context.delete($0)
        }
        try context.save()
    }

    func fetchFavoriteMealsIds() throws -> [String] {
        try context.fetch(FetchDescriptor<FavoriteMealModel>()).map(\.id)
    }
}

