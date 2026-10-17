//
//  JourneyView.swift
//  StillSpace
//
import SwiftUI

struct JourneyView: View {
    @State private var history: [SessionRecord] = []

    private var sortedHistory: [SessionRecord] {
        history.sorted { $0.completionDate > $1.completionDate }
    }

    private var totalMinutes: Int {
        Int(history.reduce(0) { $0 + $1.durationCompleted }) / 60
    }

    private var longestMinutes: Int {
        Int(history.map(\.durationCompleted).max() ?? 0) / 60
    }

    var body: some View {
        ZStack {
            StillBackground()

            VStack(alignment: .leading, spacing: 36) {
                Text("My Journey")
                    .font(.system(size: 56, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.textPrimary)

                // Stats Row
                HStack(spacing: 32) {
                    StatCard(title: "Total Sessions", value: "\(history.count)", icon: "leaf.fill")
                    StatCard(title: "Mindful Minutes", value: "\(totalMinutes)", icon: "clock.fill")
                    StatCard(title: "Longest Session", value: "\(longestMinutes) min", icon: "star.fill")
                }
                .padding(.bottom, 10)

                Text("Recent Sessions")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.textSecondary)

                if history.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "wind")
                            .font(.system(size: 48))
                            .foregroundStyle(Theme.accent.opacity(0.7))
                        Text("Your journey begins with a single breath.")
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                        Text("Complete a session and it will appear here.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 50)
                    .glassCard(cornerRadius: 16)
                } else {
                    // Unified History List
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(sortedHistory) { record in
                                SessionRow(record: record)
                                
                                // Add a subtle divider between rows (but not after the last one)
                                if record.id != sortedHistory.last?.id {
                                    Divider()
                                        .background(Theme.textTertiary.opacity(0.3))
                                        .padding(.leading, 90) // Aligns with the text, skipping the icon
                                }
                            }
                        }
                        .glassCard(cornerRadius: 16) // Wraps the entire list in one sleek container
                        .padding(.bottom, 60)
                    }
                }
            }
            .padding(.horizontal, 100)
            .padding(.top, 60)
        }
        .onAppear {
            history = PersistenceService.shared.getSessions()
        }
    }
}

private struct SessionRow: View {
    let record: SessionRecord
    @Environment(\.isFocused) private var isFocused // Tracks remote focus for scrolling

    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: "figure.mind.and.body")
                .font(.system(size: 24))
                .foregroundStyle(isFocused ? .black : Theme.accent)
                .frame(width: 50, height: 50)
                .background(Circle().fill(isFocused ? Color.black.opacity(0.1) : Theme.accent.opacity(0.12)))

            VStack(alignment: .leading, spacing: 6) {
                Text(record.sessionName)
                    .font(.headline)
                    .foregroundStyle(isFocused ? .black : Theme.textPrimary)
                Text(record.completionDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(isFocused ? .black.opacity(0.7) : Theme.textSecondary)
            }

            Spacer()

            Text("\(max(1, Int(record.durationCompleted) / 60)) min")
                .font(.headline.weight(.bold))
                .foregroundStyle(isFocused ? .black : Theme.textPrimary)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        // Flat background color change instead of 3D hover pop
        .background(isFocused ? Theme.accentLight : Color.clear)
        .focusable(true) // Required to allow the tvOS remote to scroll the list
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    var icon: String = "circle.fill"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(Theme.accentLight)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }

            Text(value)
                .font(.system(size: 48, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 16)
    }
}
