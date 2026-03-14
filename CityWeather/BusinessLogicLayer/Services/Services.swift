//
//  Services.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import Foundation

final class Services {
    
    lazy var networkService: NetworkProtocol = NetworkService()
    lazy var favouriteCitiesService: FavoritesServiceProtocol = UserDefaultsFavoritesService()
}
