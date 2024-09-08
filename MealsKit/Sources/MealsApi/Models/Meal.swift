//
//  File.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import Foundation

public struct Meal: Decodable, Identifiable {
    public let name: String
    public let id: String
    public let thumbnailImageURL: String?

    public var imageURL: URL? {
        guard let stringURL = thumbnailImageURL else { return nil }
        return URL(string: stringURL)
    }

    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case id = "idMeal"
        case thumbnailImageURL = "strMealThumb"
    }
}

public struct MealsResponse: Decodable {
    public let meals: [Meal]
}

public extension Array where Element == Meal {
    static var mock: [Meal] {
        [
            Meal(name: "White chocolate creme brulee",
                 id: "0",
                 thumbnailImageURL: "https://www.themealdb.com/images/media/meals/uryqru1511798039.jpg"),
            Meal(name: "Walnut Roll Gužvara",
                 id: "1",
                 thumbnailImageURL: "https://www.themealdb.com/images/media/meals/u9l7k81628771647.jpg")
        ]
    }
}
