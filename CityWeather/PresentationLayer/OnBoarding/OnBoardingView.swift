//
//  OnBoardingView.swift
//  CityWeather
//
//  Created by Alexandr Bahno on 11.03.2026.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appCoordinator: AppCoordinator
    @State private var onBoardingStep: OnBoardingSteps = .welcome
    
    var body: some View {
        container
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut, value: onBoardingStep)
            .toolbar(.hidden, for: .navigationBar)
    }
    
    var container: some View {
        VStack(spacing: .zero) {
            Spacer()
            TabView(selection: $onBoardingStep) {
                stepView(.welcome)
                    .tag(OnBoardingSteps.welcome)
                
                stepView(.checkWeather)
                    .tag(OnBoardingSteps.checkWeather)
                
                stepView(.searchForCity)
                    .tag(OnBoardingSteps.searchForCity)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .disabled(true)
                        
            StepIndicator(currentStep: $onBoardingStep)
                .padding(.bottom, 56.flexible())
                        
            nextButton
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func stepView(_ step: OnBoardingSteps) -> some View {
        VStack(spacing: .zero) {
            Image(systemName: step.image)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.primary2D5F5D)
                .font(.system(size: 80.flexible()))
                .fontWeight(.medium)
                .frame(width: 120.flexible(), height: 120.flexible())
                .padding(.bottom, 56.flexible())
            
            Text(step.title)
                .font(.system(size: 28.flexible()))
                .fontWeight(.medium)
                .foregroundStyle(.text1A1A1A)
                .multilineTextAlignment(.center)
                .padding([.horizontal, .bottom], 16.flexible())
            
            Text(step.description)
                .font(.system(size: 18.flexible()))
                .foregroundStyle(Color.gray666666)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16.flexible())
        }
    }
    
    var nextButton: some View {
        VStack(spacing: 8.flexible()) {
            AppStyleButton(
                text: onBoardingStep == .searchForCity ? "Start" : "Next",
                type: .withGreenBackground
            ) {
                if let nextStep = onBoardingStep.nextStep {
                    onBoardingStep = nextStep
                } else {
                    appCoordinator.completeOnboarding()
                }
            }
        }
        .padding(.horizontal, 16.flexible())
    }
}
