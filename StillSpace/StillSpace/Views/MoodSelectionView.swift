//
//  MoodSelectionView.swift
//  StillSpace
//
import SwiftUI

private enum Mood: String, CaseIterable, Identifiable {
    case overwhelmed = "Overwhelmed"
    case restless = "Restless"
    case tired = "Tired"
    case focused = "Focused"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .overwhelmed: return "cloud.fill"
        case .restless:    return "wind"
        case .tired:       return "moon.zzz.fill"
        case .focused:     return "scope"
        }
    }

    var blurb: String {
        switch self {
        case .overwhelmed, .restless: return "Slow, calming"
        case .tired:                  return "Gentle energy"
        case .focused:                return "Even, balanced"
        }
    }

    var pattern: (inhale: TimeInterval, hold: TimeInterval, exhale: TimeInterval) {
        switch self {
        case .overwhelmed, .restless: return (4, 2, 6)
        case .focused:                return (4, 4, 4)
        case .tired:                  return (6, 0, 2)
        }
    }
}

struct MoodSelectionView: View {
    private let durations = [3, 5, 10]

    @State private var selectedMood: Mood = .restless
    @State private var selectedDuration = 3

    private var pattern: (inhale: TimeInterval, hold: TimeInterval, exhale: TimeInterval) {
        selectedMood.pattern
    }

    private var patternSummary: String {
        var parts = ["Inhale \(Int(pattern.inhale))s"]
        if pattern.hold > 0 { parts.append("Hold \(Int(pattern.hold))s") }
        parts.append("Exhale \(Int(pattern.exhale))s")
        return parts.joined(separator: "  ·  ")
    }

    var body: some View {
        ZStack {
            // Keeping the standard animated background, no image added as requested
            StillBackground()

            VStack(spacing: 80) {
                
                // Mood Section
                VStack(spacing: 36) {
                    Text("How are you feeling?")
                        .font(.system(size: 56, weight: .semibold, design: .serif)) // Smaller, using serif
                        .foregroundStyle(Theme.textPrimary)

                    HStack(spacing: 32) {
                        ForEach(Mood.allCases) { mood in
                            Button { selectedMood = mood } label: {
                                VStack(spacing: 12) {
                                    Image(systemName: mood.icon)
                                        .font(.system(size: 40)) // Scaled down icon
                                        .symbolRenderingMode(.hierarchical)
                                    Text(mood.rawValue)
                                        .font(.headline)
                                        .lineLimit(1) // Prevents multi-line wrapping
                                    Text(mood.blurb)
                                        .font(.subheadline)
                                        .foregroundStyle(Theme.textSecondary)
                                }
                                // Significantly wider frame (320) to fit "Overwhelmed"
                                .frame(width: 320, height: 180)
                            }
                            .buttonStyle(StillButtonStyle(selected: selectedMood == mood, cornerRadius: 20))
                        }
                    }
                }

                // Duration Section
                VStack(spacing: 24) {
                    Text("How much time do you have?")
                        .font(.title2) // Scaled down
                        .foregroundStyle(Theme.textSecondary)

                    HStack(spacing: 32) {
                        ForEach(durations, id: \.self) { d in
                            Button { selectedDuration = d } label: {
                                Text("\(d) min")
                                    .font(.title3.weight(.medium))
                                    .frame(width: 240, height: 76) // Tighter vertical padding
                            }
                            .buttonStyle(StillButtonStyle(selected: selectedDuration == d, cornerRadius: 18))
                        }
                    }
                }

                // Start Section
                VStack(spacing: 20) {
                    NavigationLink(destination: BreathingStudioView(
                        duration: TimeInterval(selectedDuration * 60),
                        inhale: pattern.inhale,
                        hold: pattern.hold,
                        exhale: pattern.exhale
                    )) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.fill")
                                .font(.body)
                            Text("Start Breathing Session")
                                .font(.title3.weight(.semibold)) // Scaled down font
                        }
                        // Much tighter padding to reduce the button's bulk
                        .padding(.horizontal, 40)
                        .padding(.vertical, 18)
                    }
                    .buttonStyle(StillButtonStyle(prominent: true, cornerRadius: 16))

                    Text(patternSummary)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textTertiary)
                        .animation(.easeInOut, value: selectedMood)
                }
            }
            .padding(.horizontal, 60)
        }
    }
}
