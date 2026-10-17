//
//  Theme.swift
//  StillSpace
//
//  Shared design system: colours, animated background, button style, glass cards.
//
import SwiftUI

enum Theme {
    static let bgTop = Color(red: 0.04, green: 0.07, blue: 0.14)
    static let bgBottom = Color(red: 0.02, green: 0.03, blue: 0.07)
    static let accent = Color(red: 0.45, green: 0.85, blue: 0.95)
    static let accentDeep = Color(red: 0.35, green: 0.50, blue: 0.95)
    static let textPrimary = Color.white.opacity(0.95)
    static let textSecondary = Color.white.opacity(0.6)
    static let textTertiary = Color.white.opacity(0.4)
}

// MARK: - Background

/// Deep night gradient with two slowly drifting glows. Use as the base layer of every screen.
struct StillBackground: View {
    @State private var drift = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)

            Circle()
                .fill(Theme.accentDeep.opacity(0.22))
                .frame(width: 900, height: 900)
                .blur(radius: 160)
                .offset(x: drift ? -420 : -560, y: drift ? -260 : -340)

            Circle()
                .fill(Theme.accent.opacity(0.14))
                .frame(width: 700, height: 700)
                .blur(radius: 140)
                .offset(x: drift ? 640 : 520, y: drift ? 380 : 300)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 14).repeatForever(autoreverses: true)) {
                drift = true
            }
        }
    }
}

// MARK: - Button style

/// One button style for the whole app: soft glass at rest, lifted + glowing when focused.
struct StillButtonStyle: ButtonStyle {
    var prominent: Bool = false
    var selected: Bool = false
    var cornerRadius: CGFloat = 28

    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        StillButtonBody(configuration: configuration,
                        prominent: prominent,
                        selected: selected,
                        cornerRadius: cornerRadius)
    }
}

private struct StillButtonBody: View {
    let configuration: ButtonStyleConfiguration
    let prominent: Bool
    let selected: Bool
    let cornerRadius: CGFloat

    @Environment(\.isFocused) private var isFocused

    private var fill: AnyShapeStyle {
        if prominent {
            return AnyShapeStyle(LinearGradient(colors: [Theme.accent, Theme.accentDeep],
                                                startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        if selected {
            return AnyShapeStyle(Theme.accent.opacity(isFocused ? 0.35 : 0.22))
        }
        return AnyShapeStyle(Color.white.opacity(isFocused ? 0.20 : 0.07))
    }

    var body: some View {
        configuration.label
            .foregroundStyle(prominent ? Color.black.opacity(0.85) : Theme.textPrimary)
            .background(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(fill))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(selected ? Theme.accent : Color.white.opacity(isFocused ? 0.5 : 0.0),
                                  lineWidth: selected ? 3 : 2)
            )
            .scaleEffect(isFocused ? 1.07 : (configuration.isPressed ? 0.97 : 1.0))
            .shadow(color: (prominent ? Theme.accent : Color.black).opacity(isFocused ? 0.45 : 0),
                    radius: 36, y: 18)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isFocused)
    }
}

// MARK: - Glass card

extension View {
    /// Frosted card used for stats, list rows, etc.
    func glassCard(cornerRadius: CGFloat = 28) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
            )
    }
}
