//
//  DeleteSwipeView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 15.03.2026.
//

import SwiftUI

struct DeleteSwipeView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(role: .destructive) {
            action()
        } label: {
            VStack {
                Image(systemName: "trash.fill")
            }
        }
        .tint(.red)
    }
}
