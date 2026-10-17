//
//  BreathingStudioView.swift
//  StillSpace
//
import SwiftUI

struct BreathingStudioView: View {
    @StateObject private var viewModel: SessionViewModel
    @Environment(\.dismiss) private var dismiss

    private let totalDuration: TimeInterval
    private let inhaleDuration: TimeInterval
    private let exhaleDuration: TimeInterval
    private let holdDuration: TimeInterval

    init(duration: TimeInterval = 180, inhale: TimeInterval = 4.0, hold: TimeInterval = 2.0, exhale: TimeInterval = 6.0) {
        totalDuration = duration
        inhaleDuration = inhale
        holdDuration = hold
        exhaleDuration = exhale
        _viewModel = StateObject(wrappedValue: SessionViewModel(duration: duration, inhale: inhale, hold: hold, exhale: exhale))
    }

    private var isFinished: Bool { viewModel.currentPhase == .finished }

    private var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return min(1, max(0, 1 - viewModel.timeRemaining / totalDuration))
    }

    private var phaseAnimation: Animation {
        switch viewModel.currentPhase {
        case .inhale: return .easeInOut(duration: inhaleDuration)
        case .exhale: return .easeInOut(duration: exhaleDuration)
        default:      return .easeInOut(duration: max(holdDuration, 1.0))
        }
    }

    private var hint: String {
        switch viewModel.currentPhase {
        case .inhale:   return "Breathe in slowly through your nose"
        case .exhale:   return "Let it all go"
        case .finished: return "Well done. Carry this calm with you."
        default:        return "Stay with the stillness"
        }
    }

    var body: some View {
        ZStack {
            StillBackground()
            
            // Extra subtle ambient ripple effect in the background
            Circle()
                .stroke(Theme.blush.opacity(0.15), lineWidth: 2)
                .frame(width: 750, height: 750)
                .scaleEffect(viewModel.scale * 1.1)
                .opacity(viewModel.isActive ? 1 : 0.3)
                .animation(phaseAnimation, value: viewModel.scale)

            VStack(spacing: 0) {
                Spacer()

                // Phase instruction
                VStack(spacing: 18) {
                    Text(isFinished ? "Complete" : viewModel.currentPhase.rawValue)
                        .font(.system(size: 86, weight: .light, design: .serif)) // Serif matches the new cinematic aesthetic
                        .tracking(2)
                        .foregroundStyle(Theme.sand)
                        .shadow(color: Theme.bgBottom.opacity(0.5), radius: 12, y: 4)
                        .id(viewModel.currentPhase)
                        .transition(.opacity)

                    Text(hint)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .foregroundStyle(Theme.accentLight) // Soft blue for the hint
                }
                // Fixed height so the orb and controls never shift when the text changes
                .frame(maxWidth: 1000)
                .frame(height: 170)
                .animation(.easeInOut(duration: 0.6), value: viewModel.currentPhase)

                Spacer(minLength: 20)

                // Breathing orb (Redesigned with organic Sage/Sky/Blush palette)
                ZStack {
                    // Background track for progress
                    Circle()
                        .stroke(Color.white.opacity(0.08), lineWidth: 5)
                        .frame(width: 520, height: 520)
                    
                    // Session progress ring (Using the warm blush tone for contrast)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Theme.blush.opacity(0.9),
                                style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .frame(width: 520, height: 520)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: progress)

                    // Breathing layers (Organic glass effect)
                    Group {
                        // Outer soft glow
                        Circle()
                            .fill(Theme.accentLight.opacity(0.25))
                            .frame(width: 420, height: 420)
                            .scaleEffect(viewModel.scale * 1.15)
                            .blur(radius: 60)

                        // Middle layer
                        Circle()
                            .fill(Theme.accent.opacity(0.4))
                            .frame(width: 380, height: 380)
                            .scaleEffect(viewModel.scale * 1.05)
                            .blur(radius: 10)

                        // Inner core (Radial gradient of Sage to Sky Blue)
                        Circle()
                            .fill(
                                RadialGradient(colors: [Theme.accentLight, Theme.accent],
                                               center: .topLeading, startRadius: 20, endRadius: 360)
                            )
                            .frame(width: 340, height: 340)
                            .scaleEffect(viewModel.scale)
                            .shadow(color: Theme.accent.opacity(0.6), radius: 40)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.white.opacity(0.4), lineWidth: 1.5)
                                    .frame(width: 340, height: 340)
                                    .scaleEffect(viewModel.scale)
                            )
                    }
                    .animation(phaseAnimation, value: viewModel.scale)
                }
                .frame(height: 540)

                Spacer(minLength: 20)

                // Timer + controls
                VStack(spacing: 28) {
                    Text(timeString(from: viewModel.timeRemaining))
                        .font(.system(size: 44, weight: .light, design: .monospaced))
                        .tracking(3)
                        .foregroundStyle(Theme.textSecondary)

                    // Fixed height so swapping between the Done button and the round
                    // controls doesn't move the layout above it
                    Group {
                        if isFinished {
                            Button { dismiss() } label: {
                                Text("Done")
                                    .font(.title2.weight(.semibold))
                                    .padding(.horizontal, 72)
                                    .padding(.vertical, 22)
                            }
                            .buttonStyle(StillButtonStyle(prominent: true, cornerRadius: 32)) // Uses the new prominent Blush CTA style
                        } else {
                            HStack(spacing: 48) {
                                Button { viewModel.toggleSession() } label: {
                                    Image(systemName: viewModel.isActive ? "pause.fill" : "play.fill")
                                        .font(.system(size: 36))
                                        .frame(width: 100, height: 100)
                                }
                                .buttonStyle(StillButtonStyle(cornerRadius: 50))

                                Button {
                                    viewModel.endSession()
                                    dismiss()
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 36))
                                        .foregroundStyle(Theme.blush) // Use blush instead of pure red for a softer look
                                        .frame(width: 100, height: 100)
                                }
                                .buttonStyle(StillButtonStyle(cornerRadius: 50))
                            }
                        }
                    }
                    .frame(height: 100)
                }
                // Lowered from 60: tvOS already adds its own bottom safe area
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            if !viewModel.isActive && !isFinished {
                viewModel.toggleSession()
            }
        }
    }

    private func timeString(from timeInterval: TimeInterval) -> String {
        let t = max(0, Int(timeInterval))
        return String(format: "%02d:%02d", t / 60, t % 60)
    }
}
