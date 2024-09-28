//
//  MealDetails.swift
//  MealsKit
//
//  Created by Raul Mena on 9/15/24.
//

import Foundation

public struct MealDetails: Decodable {
    internal init(name: String, 
                  id: String, 
                  area: String,
                  instructions: String,
                  categoryName: String,
                  thumbnailImageURL: String? = nil,
                  youtubeURL: String? = nil,
                  ingredientAmounts: [String : String]) {
        self.name = name
        self.id = id
        self.area = area
        self.instructions = instructions
        self.categoryName = categoryName
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
        self.categoryName = try container.decode(String.self, forKey: .categoryName)
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
    public let categoryName: String
    public let thumbnailImageURL: String?
    public let youtubeURL: String?
    public let ingredientAmounts: [String: String]

    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case id = "idMeal"
        case area = "strArea"
        case categoryName = "strCategory"
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
    init(from mealDetails: [MealDetails]) {
        self = mealDetails.map {
            Meal(id: $0.id, name: $0.name, categoryName: $0.categoryName, thumbnailImageURL: $0.thumbnailImageURL)
        }
    }
}
