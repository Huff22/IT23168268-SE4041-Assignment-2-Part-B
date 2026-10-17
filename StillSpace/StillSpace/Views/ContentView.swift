//
//  ContentView.swift
//  StillSpace
//
import SwiftUI

struct ContentView: View {
    @State private var lastSession: SessionRecord?
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ZStack {
                StillBackground()

                VStack(spacing: 0) {
                    Spacer()

                    // Hero
                    VStack(spacing: 24) {
                        Image(systemName: "circle.hexagongrid.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(Theme.accent)
                            .symbolRenderingMode(.hierarchical)

                        Text("StillSpace")
                            .font(.system(size: 130, weight: .ultraLight, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(colors: [.white, Theme.accent.opacity(0.8)],
                                               startPoint: .leading, endPoint: .trailing)
                            )

                        Text("A quieter moment, on the biggest screen in your home.")
                            .font(.system(size: 36, weight: .regular))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                    Spacer()

                    // Actions
                    VStack(spacing: 40) {
                        NavigationLink(destination: MoodSelectionView()) {
                            HStack(spacing: 20) {
                                Image(systemName: "wind")
                                Text("Begin a quiet moment")
                            }
                            .font(.title2.weight(.semibold))
                            .padding(.horizontal, 70)
                            .padding(.vertical, 32)
                        }
                        .buttonStyle(StillButtonStyle(prominent: true))

                        HStack(spacing: 40) {
                            NavigationLink(destination: AmbientEscapeView()) {
                                Label("Ambient Escape", systemImage: "water.waves")
                                    .font(.title3)
                                    .padding(.horizontal, 44)
                                    .padding(.vertical, 24)
                            }
                            .buttonStyle(StillButtonStyle())

                            NavigationLink(destination: JourneyView()) {
                                Label("My Journey", systemImage: "chart.line.uptrend.xyaxis")
                                    .font(.title3)
                                    .padding(.horizontal, 44)
                                    .padding(.vertical, 24)
                            }
                            .buttonStyle(StillButtonStyle())
                        }
                    }
                    .opacity(appeared ? 1 : 0)

                    Spacer()

                    Text(lastSessionText)
                        .font(.headline)
                        .foregroundStyle(Theme.textTertiary)
                        .padding(.bottom, 60)
                }
            }
        }
        .onAppear {
            lastSession = PersistenceService.shared.getSessions()
                .max(by: { $0.completionDate < $1.completionDate })
            withAnimation(.easeOut(duration: 1.2)) { appeared = true }
        }
    }

    private var lastSessionText: String {
        guard let s = lastSession else { return "Your first session is waiting" }
        let mins = max(1, Int(s.durationCompleted) / 60)
        let when = s.completionDate.formatted(.relative(presentation: .named))
        return "Last session: \(mins) min · \(when)"
    }
}
