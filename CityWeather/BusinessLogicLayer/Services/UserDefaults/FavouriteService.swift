//
//  FavouriteService.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 14.03.2026.
//

import Foundation

protocol FavoritesServiceProtocol {
    func getFavoriteCities() -> [String]
    func addFavorite(city: String)
    func removeFavorite(city: String)
    func isFavorite(city: String) -> Bool
}

final class UserDefaultsFavoritesService: FavoritesServiceProtocol {
    private let defaults = UserDefaults.standard
    private let favoritesKey = "saved_favorite_cities"
    
    func getFavoriteCities() -> [String] {
        guard let data = defaults.data(forKey: favoritesKey),
              let cities = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return cities
    }
    
    func addFavorite(city: String) {
        var currentFavorites = getFavoriteCities()
        if !currentFavorites.contains(where: { $0 == city }) {
            currentFavorites.append(city)
            saveToDefaults(cities: currentFavorites)
        }
    }
    
    func removeFavorite(city: String) {
        var currentFavorites = getFavoriteCities()
        currentFavorites.removeAll { $0 == city }
        saveToDefaults(cities: currentFavorites)
    }
    
    func isFavorite(city: String) -> Bool {
        return getFavoriteCities().contains(where: { $0 == city })
    }
    
    private func saveToDefaults(cities: [String]) {
        if let encoded = try? JSONEncoder().encode(cities) {
            defaults.set(encoded, forKey: favoritesKey)
        }
    }
}
