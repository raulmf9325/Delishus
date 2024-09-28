//
//  Meal.swift
//  MealsKit
//
//  Created by Raul Mena on 9/23/24.
//

import MealsApi
import SwiftData

@Model
class MealModel {
    init(_ meal: Meal) {
        self.id = meal.id
        self.name = meal.name
        self.thumbnailImageURL = meal.thumbnailImageURL
        self.categoryName = meal.categoryName
    }

    @Attribute(.unique) var id: String
    var name: String
    var thumbnailImageURL: String?
    var categoryName: String?

    var meal: Meal {
        Meal(id: id,
             name: name,
             categoryName: categoryName,
             thumbnailImageURL: thumbnailImageURL)
    }
}
