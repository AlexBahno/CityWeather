//
//  CitiesListViewFactory.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Foundation
import SwiftUI

class CitiesListViewFactory {
    @ViewBuilder
    static func viewForDestination(_ destination: CitiesListDestinationFlowPage) -> some View {
        switch destination {
        case .main:
            getMainView()
        case .details:
            getDetailsView()
        }
    }
    
    static func getMainView() -> some View {
        let view = EmptyView()
        return view
    }
    static func getDetailsView() -> some View {
        let view = EmptyView()
        return view
    }
}
