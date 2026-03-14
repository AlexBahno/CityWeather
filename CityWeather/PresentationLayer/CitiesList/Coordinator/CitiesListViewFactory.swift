//
//  CitiesListViewFactory.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Foundation
import SwiftUI

/// Factory for views in CitiesList Flow
class CitiesListViewFactory {
    @ViewBuilder
    static func viewForDestination(_ destination: CitiesListDestinationFlowPage) -> some View {
        switch destination {
        case .main(let services):
            getMainView(services: services)
        case .details(let city, let services):
            getDetailsView(city: city, services.favouriteCitiesService)
        case .shareSheet(let text):
            getSheetView(text: text)
        }
    }
    
    static func getMainView(services: Services) -> some View {
        let viewModel = CitiesListViewModel(
            networkService: services.networkService,
            favouritesService: services.favouriteCitiesService
        )
        let view = CitiesListMainView(viewModel: viewModel)
        return view
    }
    
    static func getDetailsView(
        city: City,
        _ favouriteService: FavoritesServiceProtocol
    ) -> some View {
        let viewModel = CityDetailsViewModel(
            city: city, favouritesService: favouriteService
        )
        let view = CityDetailsView(viewModel: viewModel)
        return view
    }
    
    static func getSheetView(text: String) -> some View {
        let view = ShareWeatherSheet(shareText: text)
        return view
    }
}
