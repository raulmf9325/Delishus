// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeastlyKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "MealsList", targets: ["MealsList"]),
        .library(name: "MealCategoryList", targets: ["MealCategoryList"]),
        .library(name: "MealDetails", targets: ["MealDetails"]),
        .library(name: "FavoriteMealsList", targets: ["FavoriteMealsList"]),
        .library(name: "MealsApi", targets: ["MealsApi"]),
        .library(name: "MealsRepo", targets: ["MealsRepo"]),
        .library(name: "MealsRepoLive", targets: ["MealsRepoLive"]),
        .library(name: "MealsApiLive", targets: ["MealsApiLive"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "MealsApi"),
        .target(name: "MealsApiLive", dependencies: ["MealsApi"]),
        .target(name: "MealsRepo", dependencies: ["MealsApi"]),
        .target(name: "MealsRepoLive", dependencies: ["MealsRepo"]),
        .target(name: "MealsList", dependencies: ["MealsUI", "MealsApi", "MealsApiLive", "MealDetails"]),
        .target(name: "MealCategoryList", dependencies: ["MealsList", "MealsRepo"]),
        .target(name: "MealDetails", dependencies: ["MealsUI", "MealsApi", "SDWebImageSwiftUI"]),
        .target(name: "FavoriteMealsList", dependencies: ["MealsUI", "MealsRepo", "MealDetails"]),
        .target(name: "MealsUI", dependencies: ["SDWebImageSwiftUI"]),
    ]
)
