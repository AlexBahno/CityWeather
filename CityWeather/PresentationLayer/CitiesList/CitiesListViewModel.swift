//
//  CitiesListViewModel.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 13.03.2026.
//

import Foundation
import Combine
import Alamofire

final class CitiesListViewModel: ObservableObject {
    
    // properties
    let networkService: NetworkProtocol
    let favouritesService: FavoritesServiceProtocol
    @Published private(set) var state = CitiesListViewState.idle
    @Published private(set) var error: NetworkError?
    @Published private(set) var cities: [City] = []
    @Published var searchText = ""
    
    @Published var favoriteCityNames: Set<String> = []
    
    private let defaultCities: [String] = [
        "Kyiv", "Lviv", "Odesa", "Kharkiv", "Dnipro", "Uzhhorod", "Zaporizhzhia", "Vinnytsia"
    ]
    
    // MARK: - View states
    enum CitiesListViewState: Equatable {
        case idle
        case loading
        case failed
        case success
    }
    
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
        favouritesService: FavoritesServiceProtocol
    ) {
        self.networkService = networkService
        self.favouritesService = favouritesService
        
        syncFavorites()
    }
    
    func setViewState(stat: CitiesListViewState = .idle) {
        self.state = stat
    }
    
    func handleSavedButtonAction(cityName: String) {
        if favouritesService.isFavorite(city: cityName) {
            favouritesService.removeFavorite(city: cityName)
            favoriteCityNames.remove(cityName)
            return
        }
        
        favouritesService.addFavorite(city: cityName)
        favoriteCityNames.insert(cityName)
    }
    
    func syncFavorites() {
        let saved = favouritesService.getFavoriteCities()
        self.favoriteCityNames = Set(saved.map { $0 })
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
        try await withCheckedThrowingContinuation { continuation in
            networkService.executeWithCodable(request: request, parser: Parser<City>()) { result in
                switch result {
                case .success(let city):
                    continuation.resume(returning: city)
                case .failure(let error):
                    self.error = error
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
