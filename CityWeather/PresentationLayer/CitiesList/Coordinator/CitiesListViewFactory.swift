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
            getMainView(newtworkService: services.networkService)
        case .details:
            getDetailsView()
        }
    }
    
    static func getMainView(newtworkService: NetworkProtocol) -> some View {
        let viewModel = CitiesListViewModel(networkService: newtworkService)
        let view = CitiesListMainView(viewModel: viewModel)
        return view
    }
    static func getDetailsView() -> some View {
        let view = EmptyView()
        return view
    }
}
