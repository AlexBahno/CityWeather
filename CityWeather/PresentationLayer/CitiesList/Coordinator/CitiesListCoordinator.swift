//
//  CitiesCoordinator.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Combine
import SwiftUI

/// Coordinator for Cities List Flow
final class CitiesListCoordinator: BaseCoordinator {
    
    @Published var presentSheetItem: CitiesListDestinationFlowPage?
    @Published var fullCoverItem: CitiesListDestinationFlowPage?
    
    let services: Services
    
    init(services: Services) {
        self.services = services
    }
}

/// Screens protocol define as per navigation required
protocol CitiesListNavigator {
    
    func showDetails(city: City)
    func showShareSheet(textToShare: String)
}

/// Extended Base coordinator class with screen added required navigation
extension CitiesListCoordinator: CitiesListNavigator {
    
    func showDetails(city: City) {
        path.append(CitiesListDestinationFlowPage.details(city, self.services))
    }
    
    func showShareSheet(textToShare: String) {
        presentSheetItem = .shareSheet(textToShare)
    }
}

/// Define enum to identify individualy navigation trigger point
enum CitiesListDestinationFlowPage: Hashable, Identifiable {
    
    static func == (lhs: CitiesListDestinationFlowPage, rhs: CitiesListDestinationFlowPage) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    case main(Services)
    case details(City, Services)
    case shareSheet(String)
    
    var id: String {
        String(describing: self)
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .main:
            hasher.combine("main")
        case .details(let city, _):
            hasher.combine(city.name)
        case .shareSheet(let text):
            hasher.combine("shareSheet_\(text)")
        }
    }
}
