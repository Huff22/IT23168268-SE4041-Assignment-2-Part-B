//
//  JourneyView.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//

import SwiftUI

struct JourneyView: View {
    @State private var history: [SessionRecord] = []
    
    var totalMinutes: Int {
        let totalSeconds = history.reduce(0) { $0 + $1.durationCompleted }
        return Int(totalSeconds) / 60
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.08, blue: 0.12).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 50) {
                Text("My Journey")
                    .font(.system(size: 80, weight: .light, design: .rounded))
                    .foregroundColor(.white)
                
                // Top Stats Row
                HStack(spacing: 60) {
                    StatCard(title: "Total Sessions", value: "\(history.count)")
                    StatCard(title: "Mindful Minutes", value: "\(totalMinutes)")
                }
                
                Text("Recent Sessions")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.top, 20)
                
                // History List
                if history.isEmpty {
                    Text("Your journey begins with a single breath. Complete a session to see it here.")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.top, 40)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(history) { record in
                                HStack {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(record.sessionName)
                                            .font(.title3)
                                            .foregroundColor(.white)
                                        Text(record.completionDate.formatted(date: .abbreviated, time: .shortened))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text("\(Int(record.durationCompleted) / 60) min")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.cyan)
                                }
                                .padding(30)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(16)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(80)
        }
        .onAppear {
            // Load data every time the view appears
            history = PersistenceService.shared.getSessions()
        }
    }
}

// Reusable UI Component for the stats
struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundColor(.cyan)
        }
        .padding(40)
        .frame(minWidth: 350, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .cornerRadius(20)
    }
}
