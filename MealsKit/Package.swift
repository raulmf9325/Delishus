// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MealsKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MealsList", targets: ["MealsList"]),
    ],
    targets: [
        .target(
            name: "MealsApi"),
        .target(
            name: "MealsList"),
    ]
)
