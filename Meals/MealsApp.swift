//
//  mealsApp.swift
//  meals
//
//  Created by Raul Mena on 9/8/24.
//

import MealsApiLive
import CategoryList
import SwiftUI

@main
struct MealsApp: App {
    var body: some Scene {
        WindowGroup {
            CategoryListView(model: CategoryListModel(apiClient: .live))
        }
    }
}

#Preview {
    CategoryListView(model: CategoryListModel(apiClient: .test))
}
