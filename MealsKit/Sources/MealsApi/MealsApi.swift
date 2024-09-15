
import Foundation

public struct MealsApi {
    public init(getCategories: @escaping () async throws -> [MealCategory],
                getMeals: @escaping (String) async throws -> [Meal],
                getDetails: @escaping (String) async throws -> MealDetails) {
        self.getCategories = getCategories
        self.getMeals = getMeals
        self.getDetails = getDetails
    }
    
    public var getCategories: () async throws -> [MealCategory]
    public var getMeals: (String) async throws -> [Meal]
    public var getDetails: (String) async throws -> MealDetails
}

public extension MealsApi {
    static let test = Self {
        [MealCategory].mock
    } getMeals: { _ in
        [Meal].mock
    } getDetails: { _ in
        MealDetails.mock
    }

    static let failed = Self {
        throw URLError(.badServerResponse)
    } getMeals: { _ in
        throw URLError(.badServerResponse)
    } getDetails: { _ in
        throw URLError(.badServerResponse)
    }
}
