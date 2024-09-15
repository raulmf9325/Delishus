//
//  File.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import Foundation

public struct Meal: Decodable, Identifiable, Hashable {
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

public extension MealDetails {
    static let mock = Self(name: "Apple & Blackberry Crumble",
                           id: "0",
                           area: "British",
                           instructions: "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture.",
                           ingredientAmounts: ["Ice Cream" : "to serve",
                                               "Plain Flour": "120g"])
}
