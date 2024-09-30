//
//  FavoriteMeal.swift
//  MealsKit
//
//  Created by Raul Mena on 9/29/24.
//

import SwiftData

@Model
class FavoriteMealModel {
    init(id: String) {
        self.id = id
    }
    
    @Attribute(.unique) var id: String
}
