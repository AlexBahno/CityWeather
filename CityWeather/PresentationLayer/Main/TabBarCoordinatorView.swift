//
//  TabBarCoordinatorView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import SwiftUI

/// View of TabBar
struct MainTabCoordinatorView: View {
    
    @ObservedObject var tabCoordinator: TabCoordinator
    
    var body: some View {
        TabView(selection: $tabCoordinator.selectedTab) {
            
            CitiesListContentView(coordinator: tabCoordinator.citiesCoordinator)
                .tabItem {
                    Label("Список міст", systemImage: "list.bullet")
                }
                .tag(TabCoordinator.Tab.citiesList)
            
            SavedCitiesContentView(coordinator: tabCoordinator.savedCitiesCoordnitaor)
            .tabItem {
                Label("Збережені", systemImage: "star.fill")
            }
            .tag(TabCoordinator.Tab.savedCities)
        }
    }
}
