//
//  MoodSelectionView.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//
import SwiftUI

struct MoodSelectionView: View {
    let moods = ["Overwhelmed", "Restless", "Tired", "Focused"]
    let durations = [3, 5, 10]
    
    @State private var selectedMood = "Restless"
    @State private var selectedDuration = 3
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.08, blue: 0.12).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 80) {
                Text("How are you feeling?")
                    .font(.system(size: 72, weight: .light))
                    .foregroundColor(.white)
                
                // Mood Selection
                HStack(spacing: 40) {
                    ForEach(moods, id: \.self) { mood in
                        Button(action: { selectedMood = mood }) {
                            Text(mood)
                                .font(.title)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                        }
                        .buttonStyle(.card)
                        // Simple visual indicator for selected state
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedMood == mood ? Color.cyan : Color.clear, lineWidth: 4)
                        )
                    }
                }
                
                // Duration Selection
                VStack(spacing: 30) {
                    Text("How much time do you have?")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 40) {
                        ForEach(durations, id: \.self) { duration in
                            Button(action: { selectedDuration = duration }) {
                                Text("\(duration) min")
                                    .font(.title)
                                    .frame(width: 200)
                                    .padding(.vertical, 20)
                            }
                            .buttonStyle(.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedDuration == duration ? Color.cyan : Color.clear, lineWidth: 4)
                            )
                        }
                    }
                }
                
                // Navigation to Breathing Studio
                var pattern = getBreathingPattern()
                    NavigationLink(destination: BreathingStudioView(
                        duration: TimeInterval(selectedDuration * 60),
                        inhale: pattern.inhale,
                        hold: pattern.hold,
                        exhale: pattern.exhale
                    )) {
                        Text("Start Breathing Session")
                        .font(.title)
                        .fontWeight(.medium)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 25)
                }
                .buttonStyle(.plain)
                .background(Color.cyan)
                .foregroundColor(.black)
                .cornerRadius(16)
                .padding(.top, 40)
            }
        }
    }
    private func getBreathingPattern() -> (inhale: TimeInterval, hold: TimeInterval, exhale: TimeInterval) {
            switch selectedMood {
            case "Overwhelmed", "Restless":
                return (4.0, 2.0, 6.0) // Calming
            case "Focused":
                return (4.0, 4.0, 4.0) // Box/Balanced
            case "Tired":
                return (6.0, 0.0, 2.0) // Energizing
            default:
                return (4.0, 2.0, 6.0)
            }
        }
}
