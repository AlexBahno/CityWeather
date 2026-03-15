//
//  SavedCitiesCoordinator.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 15.03.2026.
//

import Combine
import SwiftUI

/// Coordinator for Saved Cities Flow
final class SavedCitiesCoordinator: BaseCoordinator {
    
    let services: Services
    
    @Published var presentSheetItem: SavedCitiesDestinationFlowPage?
    @Published var fullCoverItem: SavedCitiesDestinationFlowPage?
    
    // MARK: - init
    init(services: Services) {
        self.services = services
    }
}

/// Screens protocol define as per navigation required
protocol SavedCitiesNavigator {
    
    func showDetails(city: City)
    func showShareSheet(textToShare: String)
}

/// Extended Base coordinator class with screen added required navigation
extension SavedCitiesCoordinator: SavedCitiesNavigator {
    
    func showDetails(city: City) {
        path.append(SavedCitiesDestinationFlowPage.details(city, self.services))
    }
    
    func showShareSheet(textToShare: String) {
        presentSheetItem = .shareSheet(textToShare)
    }
}

/// Define enum to identify individualy navigation trigger point
enum SavedCitiesDestinationFlowPage: Hashable, Identifiable {
    
    static func == (
        lhs: SavedCitiesDestinationFlowPage,
        rhs: SavedCitiesDestinationFlowPage
    ) -> Bool {
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

