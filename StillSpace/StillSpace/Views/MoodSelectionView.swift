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
            StillBackground()

            VStack(spacing: 70) {
                Text("How are you feeling?")
                    .font(.system(size: 68, weight: .light, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)

                // Mood
                HStack(spacing: 36) {
                    ForEach(Mood.allCases) { mood in
                        Button { selectedMood = mood } label: {
                            VStack(spacing: 16) {
                                Image(systemName: mood.icon)
                                    .font(.system(size: 52))
                                    .symbolRenderingMode(.hierarchical)
                                Text(mood.rawValue)
                                    .font(.title3.weight(.medium))
                                Text(mood.blurb)
                                    .font(.callout)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                            .frame(width: 270, height: 220)
                        }
                        .buttonStyle(StillButtonStyle(selected: selectedMood == mood))
                    }
                }

                // Duration
                VStack(spacing: 28) {
                    Text("How much time do you have?")
                        .font(.title3)
                        .foregroundStyle(Theme.textSecondary)

                    HStack(spacing: 36) {
                        ForEach(durations, id: \.self) { d in
                            Button { selectedDuration = d } label: {
                                Text("\(d) min")
                                    .font(.title2.weight(.medium))
                                    .frame(width: 220, height: 80)
                            }
                            .buttonStyle(StillButtonStyle(selected: selectedDuration == d, cornerRadius: 22))
                        }
                    }
                }

                // Start
                VStack(spacing: 24) {
                    NavigationLink(destination: BreathingStudioView(
                        duration: TimeInterval(selectedDuration * 60),
                        inhale: pattern.inhale,
                        hold: pattern.hold,
                        exhale: pattern.exhale
                    )) {
                        Text("Start Breathing Session")
                            .font(.title2.weight(.semibold))
                            .padding(.horizontal, 70)
                            .padding(.vertical, 28)
                    }
                    .buttonStyle(StillButtonStyle(prominent: true))

                    Text(patternSummary)
                        .font(.headline)
                        .foregroundStyle(Theme.textTertiary)
                        .animation(.easeInOut, value: selectedMood)
                }
            }
            .padding(.horizontal, 80)
        }
    }
}
