//
//  ContentView.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.05, green: 0.08, blue: 0.12).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Text("StillSpace")
                        .font(.system(size: 140, weight: .ultraLight, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("A quieter moment, on the biggest screen in your home.")
                        .font(.system(size: 40, weight: .regular))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    NavigationLink(destination: MoodSelectionView()) {
                        Text("Begin a quiet moment")
                            .font(.title)
                            .padding(.horizontal, 60)
                            .padding(.vertical, 30)
                    }
                    .buttonStyle(.card)
                    
                    
                    // Add this below the MoodSelectionView NavigationLink in ContentView.swift
                        NavigationLink(destination: AmbientEscapeView()) {
                            Text("Ambient Escape")
                                .font(.title2)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                        }
                        .buttonStyle(.plain)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    
                    // Add this right below the Ambient Escape NavigationLink
                        NavigationLink(destination: JourneyView()) {
                            Text("My Journey")
                                .font(.title2)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                        }
                        .buttonStyle(.plain)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // A subtle summary of recent practice (Static for now, will connect to persistence later)
                    Text("Last session: 3 mins · Today")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.bottom, 50)
                }
            }
        }
    }
}
