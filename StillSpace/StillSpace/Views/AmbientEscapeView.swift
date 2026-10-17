//
//  AmbientEscapeView.swift
//  StillSpace
//
import SwiftUI

// Nested Data Models for the two-tier system
struct AmbientScene: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let videoName: String
}

struct AmbientCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let scenes: [AmbientScene]
}

struct AmbientEscapeView: View {
    // Mock Data: Categories containing their specific video scenes
    let categories = [
        AmbientCategory(name: "Ocean", icon: "water.waves", scenes: [
            AmbientScene(name: "Gentle Waves", videoName: "ocean_1"),
            AmbientScene(name: "Deep Blue", videoName: "ocean_2"),
            AmbientScene(name: "Shoreline", videoName: "ocean_3"),
            AmbientScene(name: "Twilight Sea", videoName: "ocean_4")
        ]),
        AmbientCategory(name: "Forest", icon: "leaf.fill", scenes: [
            AmbientScene(name: "Morning Mist", videoName: "forest_1"),
            AmbientScene(name: "Canopy", videoName: "forest_2"),
            AmbientScene(name: "Creek", videoName: "forest_3")
        ]),
        AmbientCategory(name: "Rain", icon: "cloud.rain.fill", scenes: [
            AmbientScene(name: "Light Drizzle", videoName: "rain_1"),
            AmbientScene(name: "Thunderstorm", videoName: "rain_2")
        ]),
        AmbientCategory(name: "Night Sky", icon: "moon.stars.fill", scenes: [
            AmbientScene(name: "Aurora", videoName: "night_1"),
            AmbientScene(name: "Starfield", videoName: "night_2")
        ])
    ]

    @State private var activeCategory: AmbientCategory
    @State private var activeScene: AmbientScene
    
    // tvOS Focus Tracking
    @FocusState private var focusedCategoryID: UUID?
    @FocusState private var focusedSceneID: UUID?

    @State private var showControls = true
    @State private var hideTask: Task<Void, Never>?

    init() {
        let initialCategory = categories[0]
        _activeCategory = State(initialValue: initialCategory)
        _activeScene = State(initialValue: initialCategory.scenes[0])
    }

    var body: some View {
        ZStack {
            // 1. Unobstructed Video Background
            LoopingVideoBackground(videoName: activeScene.videoName)
                .id(activeScene.videoName)
                .transition(.opacity)
                .animation(.easeInOut(duration: 1.0), value: activeScene)
                .ignoresSafeArea()
            
            // 2. Subtle bottom gradient solely to ensure button text is readable
            LinearGradient(colors: [.clear, .black.opacity(0.65)], startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()
                .opacity(showControls ? 1 : 0)
                .animation(.easeInOut(duration: 0.8), value: showControls)

            // Wake catcher: Invisible layer that catches clicks without drawing a tvOS button platter
            if !showControls {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        wake()
                    }
            }

            // 3. The UI Controls
            VStack(spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 24) {
                    
                    // Top Row: Main Categories
                    Text("Atmosphere")
                        .font(.headline)
                        .tracking(1)
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.leading, 60)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 28) {
                            ForEach(categories) { category in
                                Button(action: { wake() }) {
                                    HStack(spacing: 14) {
                                        Image(systemName: category.icon)
                                        Text(category.name)
                                            .font(.headline)
                                    }
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 18)
                                }
                                .buttonStyle(StillButtonStyle(selected: activeCategory.id == category.id, cornerRadius: 22))
                                .focused($focusedCategoryID, equals: category.id)
                            }
                        }
                        .padding(.horizontal, 60)
                        // Room so the focus scale and glow aren't clipped by the scroll view
                        .padding(.vertical, 20)
                    }
                    // Lets focus return to the categories from any scene below
                    .focusSection()
                    
                    // Bottom Row: Specific Scenes for the active category
                    Text(activeCategory.name + " Scenes")
                        .font(.headline)
                        .tracking(1)
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.leading, 60)
                        .padding(.top, 4)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 28) {
                            ForEach(activeCategory.scenes) { scene in
                                Button(action: {
                                    // Clicking a scene hides the controls to view it full screen
                                    showControls = false
                                }) {
                                    Text(scene.name)
                                        .font(.system(size: 24, weight: .semibold))
                                        .lineLimit(1)
                                        .frame(width: 270, height: 72)
                                }
                                .buttonStyle(StillButtonStyle(selected: activeScene.id == scene.id, cornerRadius: 14))
                                .focused($focusedSceneID, equals: scene.id)
                            }
                        }
                        .padding(.horizontal, 60)
                        // Room so the focus scale and glow aren't clipped by the scroll view
                        .padding(.vertical, 20)
                    }
                    // THE FIX: makes the whole row a focus target, so pressing down from
                    // "Night Sky" (which has no scene directly beneath it) still lands here
                    .focusSection()
                    .padding(.bottom, 36)
                }
            }
            .opacity(showControls ? 1 : 0)
            .disabled(!showControls)
            .animation(.easeInOut(duration: 0.8), value: showControls)
        }
        .onMoveCommand { _ in wake() }
        .onPlayPauseCommand { wake() }
        .onAppear { scheduleHide() }
        .onDisappear { hideTask?.cancel() }
        
        // When the user hovers over a top-row category, update the bottom row
        .onChange(of: focusedCategoryID) { oldID, newID in
            if let newID = newID, let category = categories.first(where: { $0.id == newID }) {
                activeCategory = category
                wake()
            }
        }
        
        // When the user hovers over a bottom-row scene, immediately preview the video
        .onChange(of: focusedSceneID) { oldID, newID in
            if let newID = newID, let scene = activeCategory.scenes.first(where: { $0.id == newID }) {
                activeScene = scene
                wake()
            }
        }
    }

    private func wake() {
        showControls = true
        scheduleHide()
    }

    private func scheduleHide() {
        hideTask?.cancel()
        hideTask = Task {
            try? await Task.sleep(nanoseconds: 6_000_000_000) // Hides after 6 seconds
            guard !Task.isCancelled else { return }
            showControls = false
        }
    }
}
