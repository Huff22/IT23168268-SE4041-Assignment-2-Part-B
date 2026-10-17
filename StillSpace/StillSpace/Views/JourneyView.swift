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

            VStack(alignment: .leading, spacing: 44) {
                Text("My Journey")
                    .font(.system(size: 76, weight: .light, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)

                HStack(spacing: 40) {
                    StatCard(title: "Total Sessions", value: "\(history.count)", icon: "leaf.fill")
                    StatCard(title: "Mindful Minutes", value: "\(totalMinutes)", icon: "clock.fill")
                    StatCard(title: "Longest Session", value: "\(longestMinutes) min", icon: "star.fill")
                }

                Text("Recent Sessions")
                    .font(.title2)
                    .foregroundStyle(Theme.textSecondary)

                if history.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "wind")
                            .font(.system(size: 64))
                            .foregroundStyle(Theme.accent.opacity(0.7))
                        Text("Your journey begins with a single breath.")
                            .font(.title3)
                            .foregroundStyle(Theme.textPrimary)
                        Text("Complete a session and it will appear here.")
                            .font(.headline)
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                    .glassCard()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 18) {
                            ForEach(sortedHistory) { record in
                                // Button purely so rows are focusable and the list scrolls with the remote
                                Button(action: {}) {
                                    SessionRow(record: record)
                                }
                                .buttonStyle(StillButtonStyle(cornerRadius: 22))
                            }
                        }
                        .padding(.vertical, 30)
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.horizontal, 90)
            .padding(.top, 60)
        }
        .onAppear {
            history = PersistenceService.shared.getSessions()
        }
    }
}

private struct SessionRow: View {
    let record: SessionRecord

    var body: some View {
        HStack(spacing: 28) {
            Image(systemName: "figure.mind.and.body")
                .font(.system(size: 34))
                .foregroundStyle(Theme.accent)
                .frame(width: 70, height: 70)
                .background(Circle().fill(Theme.accent.opacity(0.12)))

            VStack(alignment: .leading, spacing: 8) {
                Text(record.sessionName)
                    .font(.title3.weight(.medium))
                Text(record.completionDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer()

            Text("\(max(1, Int(record.durationCompleted) / 60)) min")
                .font(.title3.weight(.bold))
                .foregroundStyle(Theme.accent)
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    var icon: String = "circle.fill"

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(Theme.accent.opacity(0.8))
                Text(title)
                    .foregroundStyle(Theme.textSecondary)
            }
            .font(.headline)

            Text(value)
                .font(.system(size: 60, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.accent)
        }
        .padding(36)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 24)
    }
}
