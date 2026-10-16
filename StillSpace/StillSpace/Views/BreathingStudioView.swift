//
//  BreathingStudioView.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//
import SwiftUI

struct BreathingStudioView: View {
    @StateObject private var viewModel = SessionViewModel(duration: 180) // 3-minute default for testing
    
    var body: some View {
        ZStack {
            // Background: A deep, calming dark color
            Color(red: 0.05, green: 0.08, blue: 0.12)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 80) {
                
                // Top: Phase Instruction
                Text(viewModel.currentPhase.rawValue)
                    .font(.system(size: 96, weight: .light, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .animation(.easeInOut, value: viewModel.currentPhase)
                
                // Center: Animated Breathing Circle
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(Color.cyan.opacity(0.2))
                        .frame(width: 650, height: 650)
                        .scaleEffect(viewModel.scale * 1.1)
                        .blur(radius: 50)
                    
                    // Main circle
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 600, height: 600)
                        .scaleEffect(viewModel.scale)
                        .shadow(color: .cyan.opacity(0.5), radius: 30, x: 0, y: 0)
                }
                // Dynamic animation duration matching the breathing phase
                .animation(
                    .easeInOut(duration: viewModel.currentPhase == .inhale ? 4.0 : (viewModel.currentPhase == .exhale ? 6.0 : 1.0)),
                    value: viewModel.scale
                )
                
                // Bottom: Controls and Timer
                VStack(spacing: 40) {
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
                        .buttonStyle(.card) // Native tvOS focus styling
                        
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
            }
        }
        .onAppear {
            // Auto-start the session when the view loads
            viewModel.toggleSession()
        }
    }
    
    // Helper to format seconds into mm:ss
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    BreathingStudioView()
}
