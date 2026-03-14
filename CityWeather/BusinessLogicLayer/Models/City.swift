//
//  City.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Foundation

// MARK: - Welcome
struct City: Codable, Identifiable, Equatable {
    let id: Int
    private let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
    var primaryWeather: Weather {
        return weather[0]
    }
    
    var iconURL: URL? {
        URL(string: NetworkConstants.baseImgURL + primaryWeather.icon + ".png")
    }
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
    
    var uppercasedDescription: String {
        let capitalLetter = description.prefix(1).uppercased()
        return "\(capitalLetter)\(description.dropFirst())"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}
