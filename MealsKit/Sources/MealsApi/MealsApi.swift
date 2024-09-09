
import Foundation

public struct MealsApi {
    public init(getDesserts: @escaping () async throws -> [Meal]) {
        self.getDesserts = getDesserts
    }
    
    public var getDesserts: () async throws -> [Meal]
}

public extension MealsApi {
    static let test = Self {
        return [Meal].mock
    }

    static let failed = Self {
        throw URLError(.badServerResponse)
    }
}
