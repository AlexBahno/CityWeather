//
//  TabBarCoordinator.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Combine

/// Coordinator for TabBar
class TabCoordinator: ObservableObject {
    enum Tab { case citiesList, savedCities }
    
    @Published var selectedTab: Tab = .citiesList
    
    // Hold references to child coordinators
    let citiesCoordinator: CitiesListCoordinator
    let savedCitiesCoordnitaor: SavedCitiesCoordinator
    
    init(services: Services) {
        self.citiesCoordinator = .init(services: services)
        self.savedCitiesCoordnitaor = .init(services: services)
    }
}
