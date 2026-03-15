//
//  CityDetailsViewModel.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 14.03.2026.
//

import Combine

struct CityDetailsRouter {
    let showShareSheet: (String) -> Void
}

final class CityDetailsViewModel: ObservableObject {
    
    // properties
    let city: City
    let router: CityDetailsRouter
    private let favouritesService: FavoritesServiceProtocol
    
    @Published var isFavourite: Bool = false
    
    var textToShare: String {
        return "Погода в \(city.name): \(Int(city.main.temp))°C, \(city.primaryWeather.uppercasedDescription)"
    }
    
    // MARK: - init
    init(
        city: City,
        favouritesService: FavoritesServiceProtocol,
        router: CityDetailsRouter
    ) {
        self.city = city
        self.favouritesService = favouritesService
        self.router = router
        
        self.isFavourite = favouritesService.isFavorite(city: city.name)
    }
    
    // saving or deleting city from saved
    func handleSavedButtonAction() {
        if favouritesService.isFavorite(city: city.name) {
            favouritesService.removeFavorite(city: city.name)
            isFavourite = false
            return
        }
        
        favouritesService.addFavorite(city: city.name)
        isFavourite = true
    }
    
    func showSheet() {
        router.showShareSheet(textToShare)
    }
}
