//
//  SavedCitiesView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 15.03.2026.
//

import SwiftUI

struct SavedCitiesView: View {
    
    @StateObject var viewModel: SavedCitiesViewModel
    
    init(viewModel: SavedCitiesViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Збережені")
            .background(.white)
            .onAppear {
                viewModel.syncFavorites()
            }
            .task {
                await viewModel.fetchData()
            }
    }
    
    var content: some View {
        Group {
            switch viewModel.state {
            case .loading, .idle:
                ProgressView("Завантажується...")
            case .failed:
                VStack {
                    Text("Щось пішло не так")
                        .font(.headline)
                    Text(viewModel.error?.localizedDescription ?? "Виникла невідома помилка")
                        .foregroundColor(.secondary)
                    
                    Button("Спробувати ще раз") {
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
            if viewModel.cities.isEmpty {
                VStack {
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
                List(viewModel.cities) { city in
                    CityCellView(
                        city: city,
                        isSaved: viewModel.favouritesService.isFavorite(city: city.name)
                    )
                    .contentShape(Rectangle())
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        viewModel.router.showDetails(city)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .animation(.easeInOut, value: viewModel.cities)
    }
}
