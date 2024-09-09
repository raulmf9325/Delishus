// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MealsKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "MealsList", targets: ["MealsList"]),
        .library(name: "MealsApi", targets: ["MealsApi"]),
        .library(name: "MealsApiLive", targets: ["MealsApiLive"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "MealsApi"),
        .target(name: "MealsApiLive", dependencies: ["MealsApi"]),
        .target(name: "MealsList", dependencies: ["MealsApi", "SDWebImageSwiftUI"]),
    ]
)
