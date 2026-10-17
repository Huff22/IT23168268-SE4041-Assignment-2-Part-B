//
//  AmbientEscapeView.swift
//  StillSpace
//
import SwiftUI

struct AmbientEscapeView: View {
    let environments = [
        AmbientEnvironment(id: UUID(), name: "Ocean", imageName: "water.waves", audioName: "ocean_audio", themeColorHex: "006994"),
        AmbientEnvironment(id: UUID(), name: "Forest", imageName: "leaf.fill", audioName: "forest_audio", themeColorHex: "228B22"),
        AmbientEnvironment(id: UUID(), name: "Rain", imageName: "cloud.rain.fill", audioName: "rain_audio", themeColorHex: "4A5568"),
        AmbientEnvironment(id: UUID(), name: "Night Sky", imageName: "moon.stars.fill", audioName: "night_audio", themeColorHex: "0B1021")
    ]

    @State private var selectedEnvironment: AmbientEnvironment
    @State private var showControls = true
    @State private var hideTask: Task<Void, Never>?
    @State private var pulse = false
    @State private var drift = false

    init() {
        _selectedEnvironment = State(initialValue: environments[0])
    }

    var body: some View {
        ZStack {
            background

            // Large breathing icon: the "scene" focal point
            Image(systemName: selectedEnvironment.imageName)
                .font(.system(size: 260, weight: .ultraLight))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.white.opacity(0.18))
                .scaleEffect(pulse ? 1.06 : 0.94)
                .offset(y: -80)

            // Wake catcher: when controls are hidden, any click brings them back
            if !showControls {
                Button(action: wake) { Color.clear }
                    .buttonStyle(.plain)
            }

            controls
        }
        .onMoveCommand { _ in wake() }
        .onPlayPauseCommand { wake() }
        .onAppear {
            scheduleHide()
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) { pulse = true }
            withAnimation(.easeInOut(duration: 18).repeatForever(autoreverses: true)) { drift = true }
        }
        .onDisappear { hideTask?.cancel() }
        
        .onAppear {
                    scheduleHide()
                    withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) { pulse = true }
                    withAnimation(.easeInOut(duration: 18).repeatForever(autoreverses: true)) { drift = true }
                    
                    // Start audio for the initial environment
                    AudioManager.shared.playEnvironmentSound(filename: selectedEnvironment.audioName)
                }
                .onDisappear {
                    hideTask?.cancel()
                    AudioManager.shared.stop() // Stop audio when leaving the screen
                }
                // Change audio when the user selects a new environment
                .onChange(of: selectedEnvironment) { oldEnv, newEnv in
                    AudioManager.shared.playEnvironmentSound(filename: newEnv.audioName)
                }
    }

    // MARK: Background

    private var background: some View {
        let base = Color(hex: selectedEnvironment.themeColorHex)
        return ZStack {
            LinearGradient(colors: [base, base.opacity(0.55), .black],
                           startPoint: .top, endPoint: .bottom)

            Circle()
                .fill(.white.opacity(0.10))
                .frame(width: 800, height: 800)
                .blur(radius: 140)
                .offset(x: drift ? -300 : 300, y: drift ? -200 : -320)

            Circle()
                .fill(base.opacity(0.6))
                .frame(width: 700, height: 700)
                .blur(radius: 130)
                .offset(x: drift ? 400 : -200, y: drift ? 300 : 200)

            LinearGradient(colors: [.black.opacity(0.25), .clear, .black.opacity(0.65)],
                           startPoint: .top, endPoint: .bottom)
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 1.5), value: selectedEnvironment)
    }

    // MARK: Controls

    private var controls: some View {
        VStack {
            Spacer()

            Text(selectedEnvironment.name)
                .font(.system(size: 72, weight: .light, design: .serif))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.4), radius: 20)
                .id(selectedEnvironment.name)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.8), value: selectedEnvironment)
                .padding(.bottom, 36)

            HStack(spacing: 36) {
                ForEach(environments) { env in
                    Button {
                        selectedEnvironment = env
                        scheduleHide()
                    } label: {
                        VStack(spacing: 14) {
                            Image(systemName: env.imageName)
                                .font(.system(size: 44))
                                .symbolRenderingMode(.hierarchical)
                            Text(env.name)
                                .font(.headline)
                        }
                        .frame(width: 210, height: 150)
                    }
                    .buttonStyle(StillButtonStyle(selected: selectedEnvironment.id == env.id, cornerRadius: 24))
                }
            }
            .padding(.bottom, 70)
        }
        .opacity(showControls ? 1 : 0)
        .disabled(!showControls)
        .animation(.easeInOut(duration: 1.0), value: showControls)
    }

    // MARK: Auto-hide

    private func wake() {
        showControls = true
        scheduleHide()
    }

    private func scheduleHide() {
        hideTask?.cancel()
        hideTask = Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            guard !Task.isCancelled else { return }
            showControls = false
        }
    }
}

// Hex colour helper
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
