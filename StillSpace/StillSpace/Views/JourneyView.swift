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

            VStack(alignment: .leading, spacing: 32) {
                Text("My Journey")
                    .font(.system(size: 56, weight: .semibold, design: .serif))
                    .tracking(1)
                    .foregroundStyle(Theme.textPrimary)
                    .shadow(color: Theme.bgBottom.opacity(0.5), radius: 12, y: 4)
                    .padding(.bottom, 16)

                // Stats Row
                HStack(spacing: 40) {
                    StatCard(title: "Total Sessions", value: "\(history.count)", icon: "leaf.fill")
                    StatCard(title: "Mindful Minutes", value: "\(totalMinutes)", icon: "clock.fill")
                    StatCard(title: "Longest Session", value: "\(longestMinutes) min", icon: "star.fill")
                }
                .padding(.bottom, 8)

                Text("Recent Sessions")
                    .font(.headline.weight(.semibold))
                    .tracking(1)
                    .foregroundStyle(Theme.textSecondary)

                if history.isEmpty {
                    VStack(spacing: 18) {
                        Image(systemName: "wind")
                            .font(.system(size: 52))
                            .foregroundStyle(Theme.accent.opacity(0.8))
                        Text("Your journey begins with a single breath.")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(Theme.textPrimary)
                        Text("Complete a session and it will appear here.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary) // Was tertiary (40%), too faint on TV
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                    .glassCard(cornerRadius: 24)
                } else {
                    // Unified History List
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(sortedHistory) { record in
                                SessionRow(record: record)

                                // Subtle divider between rows (but not after the last one)
                                if record.id != sortedHistory.last?.id {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.08))
                                        .frame(height: 1)
                                        .padding(.leading, 112) // Aligns with the text, skipping the icon
                                        .padding(.trailing, 36)
                                }
                            }
                        }
                        // Clips the focused row's highlight to the container's rounded corners
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .glassCard(cornerRadius: 24) // Wraps the entire list in one sleek container
                        .padding(.vertical, 8)
                        .padding(.bottom, 40)
                    }
                }
            }
            // Reduced from 100: tvOS already adds its own safe-area inset on top of this
            .padding(.horizontal, 50)
            .padding(.top, 40)
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
                .frame(width: 52, height: 52)
                .background(Circle().fill(isFocused ? Color.black.opacity(0.1) : Theme.accent.opacity(0.14)))

            VStack(alignment: .leading, spacing: 6) {
                Text(record.sessionName)
                    .font(.body.weight(.medium))
                    .foregroundStyle(isFocused ? .black : Theme.textPrimary)
                Text(record.completionDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.callout) // Was .caption, small for 10-foot viewing
                    .foregroundStyle(isFocused ? .black.opacity(0.7) : Theme.textSecondary)
            }

            Spacer()

            Text("\(max(1, Int(record.durationCompleted) / 60)) min")
                .font(.body.weight(.bold))
                .foregroundStyle(isFocused ? .black : Theme.textPrimary)
        }
        .padding(.horizontal, 36)
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
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
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
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .padding(32)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 24)
    }
}
