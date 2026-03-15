//
//  CitiesListMainView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 13.03.2026.
//

import SwiftUI

struct CitiesListMainView: View {
    
    @StateObject var viewModel: CitiesListViewModel
    
    init(viewModel: CitiesListViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Міста")
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
                ProgressView("Завантажується...")
            case .failed:
                FailedStateView(
                    mainText: "Щось пішло не так",
                    description: viewModel.error?.localizedDescription ?? "Виникла невідома помилка") {
                        Task {
                            await viewModel.fetchData()
                        }
                    }
            case .success:
                successState
                    .animation(.easeInOut, value: viewModel.searchResults)
                    .searchable(text: $viewModel.searchText, prompt: "Шукати місто")
            }
        }
        .animation(.easeInOut, value: viewModel.state)
    }
    
    @ViewBuilder
    var successState: some View {
        if viewModel.searchResults.isEmpty {
            VStack(spacing: 16.flexible()) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFill()
                    .font(.system(size: 32.flexible()))
                    .frame(width: 32.flexible(), height: 32.flexible())
                
                Text("У списку немає міста з такою назвою")
                    .font(.headline)
                    .foregroundStyle(.text1A1A1A)
            }
        } else {
            listView
        }
    }
    
    var listView: some View {
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
                viewModel.router.showCityDetails(city)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .refreshable {
            await viewModel.fetchData()
        }
    }
}
