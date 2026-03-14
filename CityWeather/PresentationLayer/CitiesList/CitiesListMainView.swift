//
//  CitiesListMainView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 13.03.2026.
//

import SwiftUI

struct CitiesListMainView: View {
    
    @EnvironmentObject var coordinator: CitiesListCoordinator
    @StateObject var viewModel: CitiesListViewModel
    
    init(viewModel: CitiesListViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Cities")
            .background(.white)
            .onAppear {
                viewModel.syncFavorites()
            }
            .task {
                if viewModel.cities.isEmpty {
                    await viewModel.fetchData()
                }
            }
    }
    
    var content: some View {
        Group {
            switch viewModel.state {
            case .loading, .idle:
                ProgressView("Fetching weather...")
            case .failed:
                VStack {
                    Text("Something went wrong")
                        .font(.headline)
                    Text(viewModel.error?.localizedDescription ?? "Unknown error has occured")
                        .foregroundColor(.secondary)
                    
                    Button("Try Again") {
                        Task {
                            await viewModel.fetchData()
                        }
                    }
                    .padding()
                }
            case .success:
                successState
            }
        }
        .animation(.easeInOut, value: viewModel.state)
    }
    
    var successState: some View {
        Group {
            if viewModel.searchResults.isEmpty {
                VStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFill()
                        .font(.system(size: 32.flexible()))
                        .frame(width: 32.flexible(), height: 32.flexible())
                    
                    Text("There is no city with that name")
                        .font(.headline)
                        .foregroundStyle(.text1A1A1A)
                }
            } else {
                List(viewModel.searchResults) { city in
                    CityCellView(
                        city: city,
                        isSaved: viewModel.favouritesService.isFavorite(city: city.name)
                    ) {
                        viewModel.handleSavedButtonAction(cityName: city.name)
                    }
                    .contentShape(Rectangle())
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        coordinator.showDetails(city: city)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .animation(.easeInOut, value: viewModel.searchResults)
        .searchable(text: $viewModel.searchText, prompt: "Search for the city")
    }
}
