//
//  CoordinatorProtocol.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import SwiftUI
import Combine

/// Base cooridnator class with default method
class BaseCoordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func goToRoot() {
        path.removeLast(path.count)
    }
}

/// Define enum to identify individualy navigation trigger point
enum DestinationFlowPage: Hashable, Identifiable {
    
    static func == (lhs: DestinationFlowPage, rhs: DestinationFlowPage) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    case login
    case signup
    case home
    case settings
    case settingsTnC
    case settingsPnP
    case profile
    case profileDetail(user: Any)
    case homeDetail
    case generalDetail(text: String)
    
    var id: String {
        String(describing: self)
    }
    
    func hash(into hasher: inout Hasher) {
        // Hashing logic based on the enum case
        switch self {
        case .home:
            hasher.combine("home")
        case .profile:
            hasher.combine("profile")
        case .settings:
            hasher.combine("settings")
        case .login:
            hasher.combine("login")
        case .signup:
            hasher.combine("signup")
        case .settingsTnC:
            hasher.combine("settingsTnC")
        case .settingsPnP:
            hasher.combine("settingsPnP")
        case .profileDetail(_):
            hasher.combine("profileDetail")
        case .homeDetail:
            hasher.combine("homeDetail")
        case .generalDetail(_):
            hasher.combine("generalDetail")
        }
    }
}
