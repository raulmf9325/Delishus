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

public struct MealDetails: Decodable {
    internal init(name: String, 
                  id: String, 
                  area: String,
                  instructions: String,
                  thumbnailImageURL: String? = nil,
                  youtubeURL: String? = nil,
                  ingredientAmounts: [String : String]) {
        self.name = name
        self.id = id
        self.area = area
        self.instructions = instructions
        self.thumbnailImageURL = thumbnailImageURL
        self.youtubeURL = youtubeURL
        self.ingredientAmounts = ingredientAmounts
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        self.area = try container.decode(String.self, forKey: .area)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.thumbnailImageURL = try container.decodeIfPresent(String.self, forKey: .thumbnailImageURL)
        self.youtubeURL = try container.decodeIfPresent(String.self, forKey: .youtubeURL)

        var ingredientAmounts: [String: String] = [:]

        let baseIngredientString = "strIngredient"
        let baseMeasureString = "strMeasure"
        let stringContainer = try decoder.container(keyedBy: StringCodingKey.self)

        for index in (1...20) {
            let ingredientKey = baseIngredientString + "\(index)"
            let measureKey = baseMeasureString + "\(index)"

            if let ingredient = try? stringContainer.decode(String.self, forKey: StringCodingKey(stringValue: ingredientKey)),
            let measure = try? stringContainer.decode(String.self, forKey: StringCodingKey(stringValue: measureKey)),
               !ingredient.isEmpty, !measure.isEmpty {
                ingredientAmounts[ingredient] = measure
            }
        }

        self.ingredientAmounts = ingredientAmounts
    }


    public let name: String
    public let id: String
    public let area: String
    public let instructions: String
    public let thumbnailImageURL: String?
    public let youtubeURL: String?
    public let ingredientAmounts: [String: String]

    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case id = "idMeal"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbnailImageURL = "strMealThumb"
        case youtubeURL = "strYoutube"
    }

    struct StringCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?

        init(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }
}

public struct MealDetailsResponse: Decodable {
    public let meals: [MealDetails]
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
