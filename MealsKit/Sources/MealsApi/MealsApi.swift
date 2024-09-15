
import Foundation

public struct MealsApi {
    public init(getCategories: @escaping () async throws -> [MealCategory],
                getDesserts: @escaping () async throws -> [Meal],
                getDetails: @escaping (String) async throws -> MealDetails) {
        self.getCategories = getCategories
        self.getDesserts = getDesserts
        self.getDetails = getDetails
    }
    
    public var getCategories: () async throws -> [MealCategory]
    public var getDesserts: () async throws -> [Meal]
    public var getDetails: (String) async throws -> MealDetails
}

public extension MealsApi {
    static let test = Self {
        [MealCategory].mock
    } getDesserts: {
        [Meal].mock
    } getDetails: { _ in
        MealDetails.mock
    }

    static let failed = Self {
        throw URLError(.badServerResponse)
    } getDesserts: {
        throw URLError(.badServerResponse)
    } getDetails: { _ in
        throw URLError(.badServerResponse)
    }
}
