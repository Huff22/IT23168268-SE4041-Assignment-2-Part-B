//
//  BreathingStudioView.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
import SwiftUI

struct BreathingStudioView: View {
    @StateObject private var viewModel: SessionViewModel
    
    // Allow injecting a custom duration from the mood selection screen
    init(duration: TimeInterval = 180) {
        _viewModel = StateObject(wrappedValue: SessionViewModel(duration: duration))
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.08, blue: 0.12)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Top: Phase Instruction
                Text(viewModel.currentPhase.rawValue)
                    .font(.system(size: 80, weight: .light, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .animation(.easeInOut, value: viewModel.currentPhase)
                    .padding(.bottom, 40)
                
                // Center: Animated Breathing Circle
                ZStack {
                    // Outer glow (reduced base size)
                    Circle()
                        .fill(Color.cyan.opacity(0.2))
                        .frame(width: 400, height: 400)
                        .scaleEffect(viewModel.scale * 1.1)
                        .blur(radius: 50)
                    
                    // Main circle (reduced base size)
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 350, height: 350)
                        .scaleEffect(viewModel.scale)
                        .shadow(color: .cyan.opacity(0.5), radius: 30, x: 0, y: 0)
                }
                .animation(
                    .easeInOut(duration: viewModel.currentPhase == .inhale ? 4.0 : (viewModel.currentPhase == .exhale ? 6.0 : 1.0)),
                    value: viewModel.scale
                )
                
                Spacer()
                
                // Bottom: Controls and Timer
                VStack(spacing: 30) {
                    Text(timeString(from: viewModel.timeRemaining))
                        .font(.system(size: 48, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            viewModel.toggleSession()
                        }) {
                            Image(systemName: viewModel.isActive ? "pause.fill" : "play.fill")
                                .font(.system(size: 40))
                                .frame(width: 100, height: 100)
                        }
                        .buttonStyle(.card)
                        
                        Button(action: {
                            viewModel.endSession()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 40))
                                .frame(width: 100, height: 100)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.card)
                    }
                    .opacity(viewModel.currentPhase == .finished ? 0 : 1)
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            viewModel.toggleSession()
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
