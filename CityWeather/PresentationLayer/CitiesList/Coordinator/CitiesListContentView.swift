//
//  CitiesListContentView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 12.03.2026.
//

import SwiftUI

struct CitiesListContentView: View {
    
    @ObservedObject var coordinator: CitiesListCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                appContent()
                    .sheet(item: $coordinator.presentSheetItem) { present in
                        CitiesListViewFactory.viewForDestination(present)
                    }
                    .fullScreenCover(item: $coordinator.fullCoverItem) { present in
                        CitiesListViewFactory.viewForDestination(present)
                    }
                
            }
            .navigationDestination(for: CitiesListDestinationFlowPage.self) { destination in
                CitiesListViewFactory.viewForDestination(destination)
            }
        }
        .environmentObject(coordinator)
    }
    
    @ViewBuilder func appContent() -> some View {
        CitiesListViewFactory.getMainView(
            newtworkService: coordinator.services.networkService
        )
    }
}
