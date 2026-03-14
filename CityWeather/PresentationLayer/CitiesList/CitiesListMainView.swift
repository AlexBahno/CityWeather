//
//  CitiesListMainView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 13.03.2026.
//

import SwiftUI

struct CitiesListMainView: View {
    
    @EnvironmentObject var coordinator: CitiesListCoordinator
    @ObservedObject var viewModel: CitiesListViewModel
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Cities")
            .background(.white)
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
                            CityCellView(city: city)
                                .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
                .searchable(text: $viewModel.searchText, prompt: "Search for the city")
            }
        }
        .animation(.easeInOut, value: viewModel.state)
    }
}
