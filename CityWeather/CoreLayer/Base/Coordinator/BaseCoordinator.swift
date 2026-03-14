//
//  CoordinatorProtocol.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import SwiftUI
import Combine

// Base cooridnator class with default method
class BaseCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func goToRoot() {
        path.removeLast(path.count)
    }
}
