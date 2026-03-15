//
//  SavedCitiesViewModel.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 15.03.2026.
//

import Combine
import Alamofire

struct SavedCitiesRouter {
    let showDetails: (City) -> Void
}

final class SavedCitiesViewModel: ObservableObject {
    
    // properties
    let networkService: NetworkProtocol
    let favouritesService: FavoritesServiceProtocol
    let router: SavedCitiesRouter
    @Published private(set) var state = ViewState.idle
    @Published private(set) var error: NetworkError?
    
    @Published private(set) var cities: [City] = []
    @Published var favouriteCityNames: Set<String> = []
    
    // MARK: - init
    init(
        networkService: NetworkProtocol,
        favouritesService: FavoritesServiceProtocol,
        router: SavedCitiesRouter
    ) {
        self.networkService = networkService
        self.favouritesService = favouritesService
        self.router = router
        
        syncFavorites()
    }
    
    func setViewState(stat: ViewState = .idle) {
        self.state = stat
    }
    
    func syncFavorites() {
        let saved = favouritesService.getFavoriteCities()
        self.favouriteCityNames = Set(saved.map { $0 })
    }
}

// MARK: - Network
extension SavedCitiesViewModel {
    // Fetching favouriteCities
    @MainActor
    func fetchData() async {
        setViewState(stat: .loading)
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        do {
            let fetchedCities = try await withThrowingTaskGroup(of: City.self) { group in
                favouriteCityNames.map {
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
