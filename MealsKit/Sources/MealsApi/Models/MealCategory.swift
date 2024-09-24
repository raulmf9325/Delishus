//
//  MealCategory.swift
//  MealsKit
//
//  Created by Raul Mena on 9/15/24.
//

import Foundation

public struct MealCategory: Decodable, Identifiable, Hashable {
    public init(id: String, name: String, description: String, thumbnailImageURL: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnailImageURL = thumbnailImageURL
    }
    
    public let id: String
    public let name: String
    public let description: String
    public let thumbnailImageURL: String?
    
    public var imageURL: URL? {
        guard let stringURL = thumbnailImageURL else { return nil }
        return URL(string: stringURL)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case description = "strCategoryDescription"
        case thumbnailImageURL = "strCategoryThumb"
    }
}

public struct MealCategoryResponse: Decodable {
    public let categories: [MealCategory]
}


public extension Array where Element == MealCategory {
    static var mock: [MealCategory] {
        [
            MealCategory(id: "13",
                         name: "Breakfast",
                         description: "Breakfast is the first meal of a day. The word in English refers to breaking the fasting period of the previous night. There is a strong likelihood for one or more \"typical\", or \"traditional\", breakfast menus to exist in most places, but their composition varies widely from place to place, and has varied over time, so that globally a very wide range of preparations and ingredients are now associated with breakfast.",
                         thumbnailImageURL: "https://www.themealdb.com/images/category/breakfast.png"),
            MealCategory(id: "9",
                         name: "Side",
                         description: "A side dish, sometimes referred to as a side order, side item, or simply a side, is a food item that accompanies the entrée or main course at a meal. Side dishes such as salad, potatoes and bread are commonly used with main courses throughout many countries of the western world. New side orders introduced within the past decade[citation needed], such as rice and couscous, have grown to be quite popular throughout Europe, especially at formal occasions (with couscous appearing more commonly at dinner parties with Middle Eastern dishes).",
                         thumbnailImageURL: "https://www.themealdb.com/images/category/side.png")
        ]
    }
}
