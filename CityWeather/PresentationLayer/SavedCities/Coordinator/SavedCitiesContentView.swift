//
//  SavedCitiesContentView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 15.03.2026.
//

import SwiftUI

/// Starter view for Saved CIties Flow
struct SavedCitiesContentView: View {
    
    @ObservedObject var coordinator: SavedCitiesCoordinator
    @StateObject var factory: SavedCitiesViewFactory
    
    init(coordinator: SavedCitiesCoordinator) {
        self.coordinator = coordinator
        self._factory = .init(wrappedValue: .init(coordinator: coordinator))
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                appContent()
                    .sheet(item: $coordinator.presentSheetItem) { present in
                        factory.viewForDestination(present)
                    }
                    .fullScreenCover(item: $coordinator.fullCoverItem) { present in
                        factory.viewForDestination(present)
                    }
            }
            .navigationDestination(for: SavedCitiesDestinationFlowPage.self) { destination in
                factory.viewForDestination(destination)
            }
        }
    }
    
    @ViewBuilder func appContent() -> some View {
        factory.getMainView(
            services: coordinator.services
        )
    }
}
