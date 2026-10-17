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
                // 1. Solid base background for the bottom shelf
                Theme.bgBottom.ignoresSafeArea()
                
                // 2. The Hero Image with gradients
                GeometryReader { geo in
                    Image("hero_bg") // Ensure this image is in your Assets folder
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height * 0.75)
                        .clipped()
                        // Fade image to solid background color at the bottom
                        .overlay(
                            LinearGradient(
                                colors: [.clear, Theme.bgBottom.opacity(0.8), Theme.bgBottom],
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        )
                        // Left-to-right gradient to ensure text readability
                        .overlay(
                            LinearGradient(
                                colors: [Theme.bgBottom.opacity(0.95), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    
                    // TOP HEADER
                    HStack(alignment: .top) {
                        Text("STILLSPACE")
                            .font(.system(size: 26, weight: .bold, design: .serif))
                            .tracking(4)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // HERO CONTENT
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Soothe & Heal")
                            .font(.system(size: 72, weight: .semibold, design: .serif))
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Enjoy a gentle, guided breathing exercise to restore focus.")
                            .font(.title3)
                            .foregroundStyle(Theme.textSecondary)
                            .padding(.bottom, 16)
                        
                        NavigationLink(destination: MoodSelectionView()) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.fill")
                                    .font(.body)
                                Text("Begin session")
                                    .font(.headline)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                        }
                        .buttonStyle(StillButtonStyle(prominent: true, cornerRadius: 12))
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(x: appeared ? 0 : -20)
                    
                    Spacer()
                    
                    // BOTTOM SHELF
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Explore Experiences")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            Text("Choose what feels right for you")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .padding(.bottom, 8)
                        
                        // Set alignment to center so the text lines up nicely with the cards
                        HStack(alignment: .center, spacing: 32) {
                            // Card 1: Ambient
                            NavigationLink(destination: AmbientEscapeView()) {
                                BottomCardContent(
                                    icon: "water.waves",
                                    title: "Ambient Escape",
                                    subtitle: "Scenic natural worlds"
                                )
                            }
                            .buttonStyle(StillButtonStyle(cornerRadius: 16))
                            
                            // Card 2: Journey
                            NavigationLink(destination: JourneyView()) {
                                BottomCardContent(
                                    icon: "chart.line.uptrend.xyaxis",
                                    title: "My Journey",
                                    subtitle: "Saved history & times"
                                )
                            }
                            .buttonStyle(StillButtonStyle(cornerRadius: 16))
                            
                            Spacer() // Pushes the Last Session block to the far right edge
                            
                            // Last Session (Moved to bottom right)
                            if let s = lastSession {
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("LAST SESSION")
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(Theme.textSecondary)
                                        .tracking(2)
                                    Text("\(max(1, Int(s.durationCompleted) / 60)) min Breathing")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(Theme.textPrimary)
                                    Text(s.completionDate.formatted(.relative(presentation: .named)))
                                        .font(.caption)
                                        .foregroundStyle(Theme.textTertiary)
                                }
                                .opacity(appeared ? 1 : 0)
                            }
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 60)
                }
                .padding(.horizontal, 100)
            }
        }
        .onAppear {
            lastSession = PersistenceService.shared.getSessions()
                .max(by: { $0.completionDate < $1.completionDate })
            withAnimation(.easeOut(duration: 1.0)) { appeared = true }
        }
    }
}

// Reusable compact card content
private struct BottomCardContent: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(Theme.textPrimary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(width: 520, alignment: .leading)
    }
}
