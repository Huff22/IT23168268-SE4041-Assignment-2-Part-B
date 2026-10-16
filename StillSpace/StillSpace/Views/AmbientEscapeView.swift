//
//  AmbientEscapeView.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//
import SwiftUI

struct AmbientEscapeView: View {
    // Mock data based on your specific environments
    let environments = [
        AmbientEnvironment(id: UUID(), name: "Ocean", imageName: "water.waves", audioName: "ocean_audio", themeColorHex: "006994"),
        AmbientEnvironment(id: UUID(), name: "Forest", imageName: "leaf.fill", audioName: "forest_audio", themeColorHex: "228B22"),
        AmbientEnvironment(id: UUID(), name: "Rain", imageName: "cloud.rain.fill", audioName: "rain_audio", themeColorHex: "4A5568"),
        AmbientEnvironment(id: UUID(), name: "Night Sky", imageName: "moon.stars.fill", audioName: "night_audio", themeColorHex: "0B1021")
    ]
    
    @State private var selectedEnvironment: AmbientEnvironment
    @State private var showControls: Bool = true
    @State private var hideControlsTimer: Timer?
    
    init() {
        _selectedEnvironment = State(initialValue: environments[0])
    }
    
    var body: some View {
        ZStack {
            // 1. The immersive background (using colors for the prototype instead of heavy image assets)
            Color(hex: selectedEnvironment.themeColorHex)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 1.5), value: selectedEnvironment)
            
            // Subtle ambient overlay
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.3), .clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // 2. The UI Controls (Fades away)
            VStack {
                Spacer()
                
                Text(selectedEnvironment.name)
                    .font(.system(size: 64, weight: .light, design: .serif))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                // Environment Selector Carousel
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 40) {
                        ForEach(environments) { env in
                            Button(action: {
                                selectedEnvironment = env
                                resetHideTimer()
                            }) {
                                VStack(spacing: 15) {
                                    Image(systemName: env.imageName)
                                        .font(.system(size: 50))
                                    Text(env.name)
                                        .font(.headline)
                                }
                                .frame(width: 200, height: 150)
                            }
                            .buttonStyle(.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedEnvironment.id == env.id ? Color.white : Color.clear, lineWidth: 4)
                            )
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 60)
                }
            }
            .opacity(showControls ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 1.0), value: showControls)
        }
        // tvOS specific: Detect remote interactions to wake up the UI
        .onPlayPauseCommand {
            resetHideTimer()
        }
        .onAppear {
            resetHideTimer()
        }
    }
    
    // Auto-fade logic
    private func resetHideTimer() {
        showControls = true
        hideControlsTimer?.invalidate()
        hideControlsTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            showControls = false
        }
    }
}

// Utility extension to use Hex colors for our mock environments
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
