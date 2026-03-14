//
//  CityDetailsView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 14.03.2026.
//

import SwiftUI

struct CityDetailsView: View {
    
    @EnvironmentObject var coordinator: CitiesListCoordinator
    @ObservedObject var viewModel: CityDetailsViewModel
    @State private var showShareSheet = false
    
    var city: City {
        viewModel.city
    }
    
    var body: some View {
        content
            .navigationTitle(city.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
    }
    
    var content: some View {
        VStack(spacing: 24.flexible()) {
            
            header
            
            mainInfo
            
            Spacer()
            
            actionButtons
        }
    }
    
    var header: some View {
        HStack(spacing: 8.flexible()) {
            AsyncImage(url: city.iconURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                RoundedRectangle(cornerRadius: 8.flexible())
                    .fill(Color.gray9E9E9E)
                    .opacity(0.4)
                    .shimmer()
            }
            .frame(width: 36.flexible(), height: 36.flexible())
            
            VStack(spacing: 8.flexible()) {
                Text("\(Int(city.main.temp))°C")
                    .font(.system(size: 28.flexible(), weight: .medium))
                
                Text(city.primaryWeather.uppercasedDescription)
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8.flexible())
        }
        .padding(.top, 40.flexible())
    }
    
    var mainInfo: some View {
        HStack(spacing: 16.flexible()) {
            WeatherInfoCard(
                title: "Відчувається як",
                value: "\(Int(city.main.feelsLike))°C",
                icon: "thermometer"
            )
            WeatherInfoCard(
                title: "Вологість",
                value: "\(city.main.humidity)%",
                icon: "drop.fill"
            )
            WeatherInfoCard(
                title: "Вітер",
                value: "\(String(format: "%.1f", city.wind.speed)) м/с",
                icon: "wind"
            )
        }
        .padding(.horizontal)
    }
    
    var actionButtons: some View {
        HStack(spacing: 16.flexible()) {
            Button {
                withAnimation {
                    viewModel.handleSavedButtonAction()
                }
            } label: {
                Label(
                    viewModel.isFavourite ? "Прибрати" : "Додати",
                    systemImage: viewModel.isFavourite ? "bookmark.fill" : "bookmark"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            
            Button {
                coordinator.showShareSheet(textToShare: viewModel.textToShare)
            } label: {
                Label("Поділитись", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal)
        .padding(.bottom, 20.flexible())
    }
}
