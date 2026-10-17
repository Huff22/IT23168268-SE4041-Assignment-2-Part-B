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
                        // .trailing keeps the subject on the right, away from the text
                        .frame(width: geo.size.width,
                               height: geo.size.height * 0.75,
                               alignment: .trailing)
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
                            .font(.system(size: 28, weight: .semibold, design: .serif))
                            .tracking(6)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    // HERO CONTENT
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Soothe & Heal")
                            .font(.system(size: 80, weight: .semibold, design: .serif))
                            .foregroundStyle(Theme.textPrimary)
                            .shadow(color: Theme.bgBottom.opacity(0.5), radius: 12, y: 4)
                        
                        Text("Enjoy a gentle, guided breathing exercise to restore focus.")
                            .font(.title3)
                            .lineSpacing(6)
                            .foregroundStyle(Theme.textSecondary)
                            .frame(maxWidth: 760, alignment: .leading)
                            .padding(.bottom, 20)
                        
                        NavigationLink(destination: MoodSelectionView()) {
                            HStack(spacing: 14) {
                                Image(systemName: "play.fill")
                                    .font(.body)
                                Text("Begin session")
                                    .font(.headline)
                            }
                            .padding(.horizontal, 36)
                            .padding(.vertical, 18)
                        }
                        .buttonStyle(StillButtonStyle(prominent: true, cornerRadius: 20))
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(x: appeared ? 0 : -20)
                    
                    Spacer()
                    
                    // BOTTOM SHELF
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Explore Experiences")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Theme.textPrimary)
                            Text("Choose what feels right for you")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .padding(.bottom, 4)
                        
                        // Set alignment to center so the text lines up nicely with the cards
                        HStack(alignment: .center, spacing: 40) {
                            // Card 1: Ambient
                            NavigationLink(destination: AmbientEscapeView()) {
                                BottomCardContent(
                                    icon: "water.waves",
                                    title: "Ambient Escape",
                                    subtitle: "Scenic natural worlds"
                                )
                            }
                            .buttonStyle(StillButtonStyle(cornerRadius: 24))
                            
                            // Card 2: Journey
                            NavigationLink(destination: JourneyView()) {
                                BottomCardContent(
                                    icon: "chart.line.uptrend.xyaxis",
                                    title: "My Journey",
                                    subtitle: "Saved history & times"
                                )
                            }
                            .buttonStyle(StillButtonStyle(cornerRadius: 24))
                            
                            Spacer() // Pushes the Last Session block to the far right edge
                            
                            // Last Session (Moved to bottom right)
                            if let s = lastSession {
                                VStack(alignment: .trailing, spacing: 6) {
                                    Text("LAST SESSION")
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(Theme.textSecondary)
                                        .tracking(3)
                                    Text("\(max(1, Int(s.durationCompleted) / 60)) min Breathing")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(Theme.textPrimary)
                                    Text(s.completionDate.formatted(.relative(presentation: .named)))
                                        .font(.caption)
                                        .foregroundStyle(Theme.textSecondary)
                                }
                                .opacity(appeared ? 1 : 0)
                            }
                        }
                        // Groups the shelf so moving down from "Begin session" lands on the cards predictably
                        .focusSection()
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 60)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 16)
                    .animation(.easeOut(duration: 0.9).delay(0.2), value: appeared)
                }
                // Reduced from 100: tvOS already adds its own safe-area inset on top of this
                .padding(.horizontal, 50)
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
        HStack(spacing: 22) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(Theme.textPrimary)
                .frame(width: 48, height: 48) // Keeps icons aligned across cards
            
            VStack(alignment: .leading, spacing: 6) {
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
        .padding(.horizontal, 28)
        .padding(.vertical, 24)
        .frame(width: 520, alignment: .leading)
    }
}
