//
//  MealCategoryModel.swift
//  MealsKit
//
//  Created by Raul Mena on 9/23/24.
//

import MealsApi
import SwiftData

@Model
class MealCategoryModel {
    init(_ mealCategory: MealCategory) {
        self.id = mealCategory.id
        self.name = mealCategory.name
        self.descriptionText = mealCategory.description
        self.thumbnailImageURL = mealCategory.thumbnailImageURL
    }

    @Attribute(.unique) var id: String
    var name: String
    var descriptionText: String
    var thumbnailImageURL: String?

    var mealCategory: MealCategory {
        MealCategory(id: id,
                     name: name,
                     description: descriptionText,
                     thumbnailImageURL: thumbnailImageURL)
    }
}
