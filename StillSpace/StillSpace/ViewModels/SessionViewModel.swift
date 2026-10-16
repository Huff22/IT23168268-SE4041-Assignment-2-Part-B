//
//  SessionViewModel.swift
//  StillSpace
//
//  Created by Hafsa Faleel on 2026-10-16.
//
import Foundation
import Combine

enum BreathingPhase: String {
    case inhale = "Breathe In..."
    case hold = "Hold..."
    case exhale = "Breathe Out..."
    case finished = "Session Complete"
}

class SessionViewModel: ObservableObject {
    @Published var currentPhase: BreathingPhase = .inhale
    @Published var timeRemaining: TimeInterval
    @Published var isActive: Bool = false
    @Published var scale: CGFloat = 1.0 // Drives the SwiftUI circle animation
    
    let totalDuration: TimeInterval
    private var timer: Timer?
    private var phaseTimer: Timer?
    
    // 4-2-6 Breathing Pattern
    private let inhaleDuration: TimeInterval
    private let holdDuration: TimeInterval
    private let exhaleDuration: TimeInterval
    
    init(duration: TimeInterval = 180, inhale: TimeInterval = 4.0, hold: TimeInterval = 2.0, exhale: TimeInterval = 6.0) {
            self.totalDuration = duration
            self.timeRemaining = duration
            self.inhaleDuration = inhale
            self.holdDuration = hold
            self.exhaleDuration = exhale
    }
    
    func toggleSession() {
        if isActive {
            pauseSession()
        } else {
            startSession()
        }
    }
    
    private func startSession() {
        isActive = true
        
        // Main countdown timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.endSession()
            }
        }
        
        // Start the breathing cycle
        triggerInhale()
    }
    
    private func pauseSession() {
        isActive = false
        timer?.invalidate()
        phaseTimer?.invalidate()
    }
    
    func endSession() {
        pauseSession()
        currentPhase = .finished
        timeRemaining = 0
        scale = 1.0
        // Here we will eventually trigger the persistence service to save a SessionRecord
    }
    
    // MARK: - Breathing Cycle Logic
    
    private func triggerInhale() {
        guard isActive else { return }
        currentPhase = .inhale
        scale = 1.5 // Expand circle
        
        phaseTimer = Timer.scheduledTimer(withTimeInterval: inhaleDuration, repeats: false) { [weak self] _ in
            self?.triggerHold()
        }
    }
    
    private func triggerHold() {
        guard isActive else { return }
        currentPhase = .hold
        scale = 1.5 // Maintain size
        
        phaseTimer = Timer.scheduledTimer(withTimeInterval: holdDuration, repeats: false) { [weak self] _ in
            self?.triggerExhale()
        }
    }
    
    private func triggerExhale() {
        guard isActive else { return }
        currentPhase = .exhale
        scale = 1.0 // Shrink circle
        
        phaseTimer = Timer.scheduledTimer(withTimeInterval: exhaleDuration, repeats: false) { [weak self] _ in
            self?.triggerInhale() // Loop back to start
        }
    }
}
