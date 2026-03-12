//
//  CityWeatherApp.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 11.03.2026.
//

import SwiftUI

@main
struct CityWeatherApp: App {
    
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appCoordinator.hasFinishedOnboarding {
                    MainTabCoordinatorView()
                } else {
                    OnboardingView(appCoordinator: appCoordinator)
                }
            }
        }
    }
}
