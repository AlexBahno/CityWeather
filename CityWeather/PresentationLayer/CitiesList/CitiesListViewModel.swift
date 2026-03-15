//
//  CitiesListViewModel.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 13.03.2026.
//

import Foundation
import Combine
import Alamofire

struct CitiesListRouter {
    let showCityDetails: (City) -> Void
}

final class CitiesListViewModel: ObservableObject {
    
    // properties
    private let router: CitiesListRouter
    private let networkService: NetworkProtocol
    private let favouritesService: FavoritesServiceProtocol
    
    @Published var searchText = ""
    @Published var favouriteCityNames: Set<String> = []
    @Published private(set) var state = ViewState.idle
    @Published private(set) var error: NetworkError?
    @Published private(set) var cities: [City] = []
    
    private let defaultCities: [String] = [
        "Kyiv", "Lviv", "Odesa", "Kharkiv", "Dnipro", "Uzhhorod", "Zaporizhzhia", "Vinnytsia"
    ]
    
    var searchResults: [City] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.name.containsCharactersInOrder(of: searchText) }
        }
    }
    
    // MARK: - init
    init(
        networkService: NetworkProtocol,
        favouritesService: FavoritesServiceProtocol,
        router: CitiesListRouter
    ) {
        self.networkService = networkService
        self.favouritesService = favouritesService
        self.router = router
        
        syncFavorites()
    }
    
    func setViewState(stat: ViewState = .idle) {
        self.state = stat
    }
    
    func handleSavedButtonAction(cityName: String) {
        if favouritesService.isFavorite(city: cityName) {
            favouritesService.removeFavorite(city: cityName)
            favouriteCityNames.remove(cityName)
            return
        }
        
        favouritesService.addFavorite(city: cityName)
        favouriteCityNames.insert(cityName)
    }
    
    func syncFavorites() {
        let saved = favouritesService.getFavoriteCities()
        self.favouriteCityNames = Set(saved.map { $0 })
    }
    
    func showDetailsView(for city: City) {
        router.showCityDetails(city)
    }
    
    func isCitySaved(cityName: String) -> Bool {
        favouritesService.isFavorite(city: cityName)
    }
}

// MARK: - Network
extension CitiesListViewModel {
    
    // Fetching defaultCities
    @MainActor
    func fetchData() async {
        setViewState(stat: .loading)
        
        try? await Task.sleep(nanoseconds: 700_000_000)
        
        do {
            let fetchedCities = try await withThrowingTaskGroup(of: City.self) { group in
                defaultCities.map {
                    Request(
                        path: "",
                        method: .get,
                        parameters: [
                            "q": $0,
                            "appid": NetworkConstants.apiKey,
                            "units": "metric",
                            "lang": "ua"
                        ]
                    )
                }
                .forEach { request in
                    group.addTask {
                        return try await self.fetchSingleCityAsync(request: request)
                    }
                }
                
                var results: [City] = []
                for try await city in group {
                    results.append(city)
                }
                return results
            }
            
            self.cities = fetchedCities
            setViewState(stat: .success)
        } catch {
            setViewState(stat: .failed)
        }
    }
    
    // Fetch single city from api
    private func fetchSingleCityAsync(request: Request) async throws -> City {
        do {
            return try await networkService.executeWithCodable(request: request, parser: Parser<City>())
        } catch {
            self.error = error as? NetworkError
            throw error
        }
    }
}
