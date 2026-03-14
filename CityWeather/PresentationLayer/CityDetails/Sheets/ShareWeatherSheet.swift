//
//  ShareWeatherSheet.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 14.03.2026.
//

import SwiftUI

struct ShareWeatherSheet: View {
    
    let shareText: String
    @Environment(\.dismiss) private var dismiss
    
    @State private var isCopied: Bool = false
    
    var body: some View {
        VStack(spacing: 24.flexible()) {
            Text("Поділитись прогнозом")
                .font(.headline)
                .padding(.top, 24.flexible())
            
            Text(shareText)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12.flexible())
                .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 16.flexible()) {
                Button(action: copyToClipboard) {
                    Label(
                        isCopied ? "Скопійовано!" : "Скопіювати",
                        systemImage: isCopied ? "checkmark" : "doc.on.doc"
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isCopied ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12.flexible())
                    .animation(.easeInOut, value: isCopied)
                }
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Закрити")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .foregroundColor(.primary)
                        .cornerRadius(12.flexible())
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32.flexible())
        }
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = shareText
        isCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isCopied = false
        }
    }
}
