//
//  OnBoardingSteps.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Foundation

enum OnBoardingSteps: Int, CaseIterable, Identifiable {
    case welcome = 0
    case checkWeather = 1
    case searchForCity = 2
    
    var id: Self { self }
    
    var image: String {
        switch self {
        case .welcome: "cloud.sun.bolt.fill"
        case .checkWeather: "thermometer.sun.fill"
        case .searchForCity: "magnifyingglass.circle.fill"
        }
    }
    
    var title: String {
        switch self {
        case .welcome: "Welcome to\nCityWeather"
        case .checkWeather: "Live Weather\nat a Glance"
        case .searchForCity: "Explore Any\nCity on Earth"
        }
    }
    
    var description: String {
        switch self {
        case .welcome:
            "Your personal window to the sky. Accurate, beautiful, and always up to date — wherever you are"
        case .checkWeather:
            "See real-time temperature, humidity, wind speed, and forecasts for any city — all in one beautiful view"
        case .searchForCity:
            "Search thousands of cities instantly. Save your favourites and switch between them with a single tap."
        }
    }
    
    var nextStep: Self? {
        switch self {
        case .welcome: .checkWeather
        case .checkWeather: .searchForCity
        case .searchForCity: nil
        }
    }
}
