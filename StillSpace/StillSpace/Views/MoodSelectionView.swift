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

            VStack(spacing: 64) {
                
                // Mood Section
                VStack(spacing: 40) {
                    Text("How are you feeling?")
                        .font(.system(size: 56, weight: .semibold, design: .serif)) // Smaller, using serif
                        .tracking(1)
                        .foregroundStyle(Theme.textPrimary)
                        .shadow(color: Theme.bgBottom.opacity(0.5), radius: 12, y: 4)

                    HStack(spacing: 40) {
                        ForEach(Mood.allCases) { mood in
                            Button { selectedMood = mood } label: {
                                VStack(spacing: 14) {
                                    Image(systemName: mood.icon)
                                        .font(.system(size: 44))
                                        .symbolRenderingMode(.hierarchical)
                                        .frame(height: 52) // Keeps icons on one baseline
                                    VStack(spacing: 6) {
                                        Text(mood.rawValue)
                                            .font(.headline)
                                            .lineLimit(1) // Prevents multi-line wrapping
                                        Text(mood.blurb)
                                            .font(.subheadline)
                                            .foregroundStyle(Theme.textSecondary)
                                            .lineLimit(1)
                                    }
                                }
                                // Wide frame (320) to fit "Overwhelmed"
                                .frame(width: 320, height: 200)
                            }
                            .buttonStyle(StillButtonStyle(selected: selectedMood == mood, cornerRadius: 28))
                        }
                    }
                    // Lets focus move down from any card, not only the one directly above a button
                    .focusSection()
                }

                // Duration Section
                VStack(spacing: 28) {
                    Text("How much time do you have?")
                        .font(.headline)
                        .tracking(1)
                        .foregroundStyle(Theme.textSecondary)

                    HStack(spacing: 40) {
                        ForEach(durations, id: \.self) { d in
                            Button { selectedDuration = d } label: {
                                Text("\(d) min")
                                    .font(.title3.weight(.medium))
                                    .frame(width: 240, height: 80)
                            }
                            .buttonStyle(StillButtonStyle(selected: selectedDuration == d, cornerRadius: 24))
                        }
                    }
                    .focusSection()
                }

                // Start Section
                VStack(spacing: 24) {
                    NavigationLink(destination: BreathingStudioView(
                        duration: TimeInterval(selectedDuration * 60),
                        inhale: pattern.inhale,
                        hold: pattern.hold,
                        exhale: pattern.exhale
                    )) {
                        HStack(spacing: 14) {
                            Image(systemName: "play.fill")
                                .font(.body)
                            Text("Start Breathing Session")
                                .font(.headline.weight(.semibold))
                        }
                        .padding(.horizontal, 48)
                        .padding(.vertical, 20)
                    }
                    .buttonStyle(StillButtonStyle(prominent: true, cornerRadius: 20))

                    Text(patternSummary)
                        .font(.subheadline)
                        .tracking(0.5)
                        .foregroundStyle(Theme.textSecondary)
                        .animation(.easeInOut, value: selectedMood)
                }
            }
            .padding(.horizontal, 60)
        }
    }
}
