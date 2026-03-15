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
                FailedStateView(
                    mainText: "Щось пішло не так",
                    description: viewModel.error?.localizedDescription ?? "Виникла невідома помилка") {
                        Task {
                            await viewModel.fetchData()
                        }
                    }
            case .success:
                successState
                    .animation(.easeInOut, value: viewModel.cities)
            }
        }
        .animation(.easeInOut, value: viewModel.state)
    }
    
    @ViewBuilder
    var successState: some View {
        if viewModel.cities.isEmpty {
            VStack(spacing: 16.flexible()) {
                Image(systemName: "bookmark")
                    .resizable()
                    .scaledToFill()
                    .font(.system(size: 32.flexible()))
                    .frame(width: 32.flexible(), height: 32.flexible())
                
                Text("Списко поки що порожній")
                    .font(.headline)
                    .foregroundStyle(.text1A1A1A)
            }
        } else {
            listView
        }
    }
    
    var listView: some View {
        List(viewModel.cities) { city in
            CityCellView(
                city: city,
                isSaved: viewModel.isCitySaved(cityName: city.name)
            )
            .contentShape(Rectangle())
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                DeleteSwipeView {
                    withAnimation {
                        viewModel.deleteFromSaved(city: city)
                    }
                }
            }
            .listRowBackground(Color.clear)
            .onTapGesture {
                viewModel.showDetailsView(for: city)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .refreshable {
            await viewModel.fetchData()
        }
    }
}
