
import Foundation

public struct MealsApi {
    public init(getDesserts: @escaping () async throws -> [Meal],
                getDetails: @escaping (String) async throws -> MealDetails) {
        self.getDesserts = getDesserts
        self.getDetails = getDetails
    }
    
    public var getDesserts: () async throws -> [Meal]
    public var getDetails: (String) async throws -> MealDetails
}

public extension MealsApi {
    static let test = Self {
        [Meal].mock
    } getDetails: { _ in
        MealDetails.mock
    }

    static let failed = Self {
        throw URLError(.badServerResponse)
    } getDetails: { _ in
        throw URLError(.badServerResponse)
    }
}
