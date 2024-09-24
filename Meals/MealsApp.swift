//
//  mealsApp.swift
//  meals
//
//  Created by Raul Mena on 9/8/24.
//

import MealsApiLive
import MealCategoryList
import SwiftUI

@main
struct MealsApp: App {
    var body: some Scene {
        WindowGroup {
            MealCategoryListView(model: MealCategoryListModel(apiClient: .live))
        }
    }
}

#Preview {
    MealCategoryListView(model: MealCategoryListModel(apiClient: .test))
}
