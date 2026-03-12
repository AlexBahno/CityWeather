//
//  AppCoordinator.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @AppStorage(AppStorageConstants.isOnBoardingFinishedKey) var hasFinishedOnboarding: Bool = false
    
    func completeOnboarding() {
        hasFinishedOnboarding = true
    }
}
