//
//  MealsApiLive.swift
//
//
//  Created by Raul Mena on 9/8/24.
//

import Foundation
import MealsApi

public extension MealsApi {
    static let live = Self(getDesserts: fetchDesserts)
}

private func fetchDesserts() async throws -> [Meal] {
    let urlRequest = try makeURLRequest(appending: "filter.php?c=Dessert")
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200, !data.isEmpty else {
        throw URLError(.badServerResponse)
    }

    return try JSONDecoder().decode(MealsResponse.self, from: data).meals
}

private func makeURLRequest(appending query: String) throws -> URLRequest {
    let stringURL = baseURL.appending(query)
    
    guard let url = URL(string: stringURL) else {
        throw URLError(.badURL)
    }

    let urlRequest = URLRequest(url: url)
    return urlRequest
}

private let baseURL = "https://themealdb.com/api/json/v1/1/"
