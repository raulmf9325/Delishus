//
//  File.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import Foundation

public struct Meal: Decodable, Identifiable, Hashable {
    public init(id: String,
                name: String,
                categoryName: String?,
                thumbnailImageURL: String? = nil) {
        self.id = id
        self.name = name
        self.categoryName = categoryName
        self.thumbnailImageURL = thumbnailImageURL
    }

    public let id: String
    public let name: String
    public let thumbnailImageURL: String?
    public var categoryName: String?


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
            Meal(id: "0",
                 name: "White chocolate creme brulee",
                 categoryName: "Dessert",
                 thumbnailImageURL: "https://www.themealdb.com/images/media/meals/uryqru1511798039.jpg"),
            Meal(id: "1",
                 name: "Walnut Roll Gužvara",
                 categoryName: "Dessert",
                 thumbnailImageURL: "https://www.themealdb.com/images/media/meals/u9l7k81628771647.jpg")
        ]
    }
}

public extension MealDetails {
    static let mock = Self(name: "Apple & Blackberry Crumble",
                           id: "0",
                           area: "British",
                           instructions: "Heat oven to 190C/170C fan/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture.",
                           categoryName: "Dessert",
                           ingredientAmounts: ["Ice Cream" : "to serve",
                                               "Plain Flour": "120g"])
}
