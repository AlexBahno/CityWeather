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
        case .welcome: "Вітаємо у\nCityWeather"
        case .checkWeather: "Актуальна погода\nз першого погляду"
        case .searchForCity: "Досліджуй будь-яке\nмісто на Землі"
        }
    }
    
    var description: String {
        switch self {
        case .welcome:
            "Твоє особисте вікно у небо. Точний, красивий та завжди актуальний прогноз — де б ти не був."
        case .checkWeather:
            "Дізнавайся температуру в реальному часі, вологість, швидкість вітру та прогноз для будь-якого міста — усе на одному зручному екрані."
        case .searchForCity:
            "Миттєво шукай серед тисяч міст. Зберігай улюблені та перемикайся між ними в один дотик."
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
