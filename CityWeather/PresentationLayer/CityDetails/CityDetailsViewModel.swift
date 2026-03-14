//
//  CityDetailsViewModel.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 14.03.2026.
//

import Combine

final class CityDetailsViewModel: ObservableObject {
    
    let city: City
    
    // Стан саме для UI цього екрану
    @Published var isFavourite: Bool = false
    
    // Посилання на наш глобальний сервіс
    private let favouritesService: FavoritesServiceProtocol
    
    var textToShare: String {
        return "Погода в \(city.name): \(Int(city.main.temp))°C, \(city.primaryWeather.uppercasedDescription)"
    }
    
    init(city: City, favouritesService: FavoritesServiceProtocol) {
        self.city = city
        self.favouritesService = favouritesService
        
        self.isFavourite = favouritesService.isFavorite(city: city.name)
    }
    
    func handleSavedButtonAction() {
        if favouritesService.isFavorite(city: city.name) {
            favouritesService.removeFavorite(city: city.name)
            isFavourite = false
            return
        }
        
        favouritesService.addFavorite(city: city.name)
        isFavourite = true
    }
}
