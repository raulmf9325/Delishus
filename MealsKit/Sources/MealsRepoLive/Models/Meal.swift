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
    }

    @Attribute(.unique) var id: String
    var name: String
    var thumbnailImageURL: String?

    var meal: Meal {
        Meal(name: name, id: id, thumbnailImageURL: thumbnailImageURL)
    }
}
