//
//  CitiesCoordinator.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Combine
import SwiftUI

final class CitiesListCoordinator: BaseCoordinator {
    
    @Published var presentSheetItem: CitiesListDestinationFlowPage?
    @Published var fullCoverItem: CitiesListDestinationFlowPage?
}

/// screens protocol define as per navigation required
protocol CitiesListNavigator {
    func showDetails()
}

/// Extended Base coordinator class with screen added required navigation
extension CitiesListCoordinator: CitiesListNavigator {
    func showDetails() {
        path.append(CitiesListDestinationFlowPage.details)
    }
}

/// Define enum to identify individualy navigation trigger point
enum CitiesListDestinationFlowPage: Hashable, Identifiable {
    static func == (lhs: CitiesListDestinationFlowPage, rhs: CitiesListDestinationFlowPage) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    case main
    case details
    
    var id: String {
        String(describing: self)
    }
    
    func hash(into hasher: inout Hasher) {
        // Hashing logic based on the enum case
        switch self {
        case .main:
            hasher.combine("main")
        case .details:
            hasher.combine("details")
        }
    }
}
