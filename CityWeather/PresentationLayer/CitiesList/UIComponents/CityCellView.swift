//
//  CityCellView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 14.03.2026.
//

import SwiftUI

struct CityCellView: View {
    
    let city: City
    let isSaved: Bool
    
    let savedAction: () -> Void
    
    var body: some View {
        content
            .padding(.vertical, 8.flexible())
            .padding(.horizontal, 16.flexible())
    }
    
    var content: some View {
        HStack(spacing: 8.flexible()) {
            image
            
            description
            
            Spacer()
            
            Button {
                withAnimation {
                    savedAction()
                }
            } label: {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(.yellow)
                    .frame(width: 24.flexible(), height: 24.flexible())
            }
            .buttonStyle(.plain)
        }
    }
    
    var image: some View {
        AsyncImage(url: city.iconURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            RoundedRectangle(cornerRadius: 8.flexible())
                .fill(Color.gray9E9E9E)
                .opacity(0.4)
                .shimmer()
        }
        .frame(width: 48.flexible(), height: 48.flexible())
    }
    
    var description: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("\(city.name), \(Int(city.main.temp))°C")
                .font(.system(size: 24.flexible()))
                .foregroundStyle(.text1A1A1A)
            
            Spacer()
            
            Text(city.primaryWeather.uppercasedDescription)
                .font(.system(size: 20.flexible()))
                .foregroundStyle(.text1A1A1A.opacity(0.9))
        }
    }
}
