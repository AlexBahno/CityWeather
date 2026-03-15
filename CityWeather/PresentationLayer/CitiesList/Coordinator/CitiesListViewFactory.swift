//
//  CitiesListViewFactory.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Foundation
import SwiftUI
import Combine

/// Factory for views in CitiesList Flow
class CitiesListViewFactory: ObservableObject {
    
    private let coordinator: CitiesListCoordinator
    
    // MARK: - init
    init(coordinator: CitiesListCoordinator) {
        self.coordinator = coordinator
    }
    
    @ViewBuilder
    func viewForDestination(_ destination: CitiesListDestinationFlowPage) -> some View {
        switch destination {
        case .main(let services):
            getMainView(services: services)
        case .details(let city, let services):
            getDetailsView(city: city, services.favouriteCitiesService)
        case .shareSheet(let text):
            getSheetView(text: text)
        }
    }
    
    func getMainView(services: Services) -> some View {
        let router = CitiesListRouter { [weak self] city in
            self?.coordinator.showDetails(city: city)
        }
        let viewModel = CitiesListViewModel(
            networkService: services.networkService,
            favouritesService: services.favouriteCitiesService,
            router: router
        )
        let view = CitiesListMainView(viewModel: viewModel)
        return view
    }
    
    func getDetailsView(
        city: City,
        _ favouriteService: FavoritesServiceProtocol
    ) -> some View {
        let router = CityDetailsRouter { [weak self] textToShare in
            self?.coordinator.showShareSheet(textToShare: textToShare)
        }
        let viewModel = CityDetailsViewModel(
            city: city,
            favouritesService: favouriteService,
            router: router
        )
        let view = CityDetailsView(viewModel: viewModel)
        return view
    }
    
    func getSheetView(text: String) -> some View {
        let view = ShareWeatherSheet(shareText: text)
        return view
    }
}
