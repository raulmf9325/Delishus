//
//  mealsApp.swift
//  meals
//
//  Created by Raul Mena on 9/8/24.
//

import MealsList
import SwiftUI

@main
struct mealsApp: App {
    var body: some Scene {
        WindowGroup {
            MealsListView()
        }
    }
}

#Preview {
    MealsListView()
}
