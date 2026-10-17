import SwiftUI

enum Theme {
    // Calming earthy palette from image_2.png
    static let bgTop = Color(hex: "1F2D24")        // Dark forest/sage
    static let bgBottom = Color(hex: "111B15")     // Deep shadow forest
    static let accent = Color(hex: "5E8B7E")       // Sage Green
    static let accentLight = Color(hex: "A7C7E7")  // Pastel Sky Blue
    static let blush = Color(hex: "E8AEB7")        // Soft Dusty Rose (Prominent)
    static let sand = Color(hex: "F1F5F4")         // Off-white/Sand for readable text
    
    static let textPrimary = Color.white.opacity(0.95)
    static let textSecondary = Color.white.opacity(0.65)
    static let textTertiary = Color.white.opacity(0.4)
}

// MARK: - Natural Animated Background
struct StillBackground: View {
    @State private var drift = false

    var body: some View {
        ZStack {
            // Warm-dark forest backdrop
            LinearGradient(colors: [Theme.bgTop, Theme.bgBottom], startPoint: .top, endPoint: .bottom)

            // Slowly moving organic ambient glow (Sage/Teal)
            Circle()
                .fill(Theme.accent.opacity(0.18))
                .frame(width: 950, height: 950)
                .blur(radius: 170)
                .offset(x: drift ? -350 : -480, y: drift ? -220 : -300)

            // Dynamic ambient highlight (Rose/Blush)
            Circle()
                .fill(Theme.blush.opacity(0.08))
                .frame(width: 800, height: 800)
                .blur(radius: 150)
                .offset(x: drift ? 550 : 420, y: drift ? 300 : 250)
        }
        .drawingGroup() // Renders the blurred layers once via Metal instead of every frame
        .allowsHitTesting(false)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 16).repeatForever(autoreverses: true)) {
                drift = true
            }
        }
    }
}

// MARK: - Redesigned Button Styles
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

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    private var fill: AnyShapeStyle {
        if prominent {
            // Dusty rose/peach highlight for important CTA
            return AnyShapeStyle(LinearGradient(colors: [Theme.blush, Theme.blush.opacity(isFocused ? 0.92 : 0.85)],
                                                startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        if selected {
            return AnyShapeStyle(Theme.accent.opacity(isFocused ? 0.35 : 0.22))
        }
        // Transparent glass state at rest
        return AnyShapeStyle(Color.white.opacity(isFocused ? 0.18 : 0.06))
    }

    private var shadowColor: Color {
        if prominent { return Theme.blush }
        if selected { return Theme.accent }
        return Color.black
    }

    var body: some View {
        configuration.label
            .foregroundStyle(prominent ? Color(hex: "2D1419") : Theme.textPrimary) // Darker text for rose CTA
            .background(shape.fill(fill))
            .overlay(
                shape.strokeBorder(
                    selected ? Theme.accentLight : Color.white.opacity(isFocused ? 0.35 : 0.0),
                    lineWidth: selected ? 3 : 1.5
                )
            )
            .contentShape(shape)
            .scaleEffect(isFocused ? 1.04 : (configuration.isPressed ? 0.98 : 1.0))
            .shadow(color: shadowColor.opacity(isFocused ? 0.32 : 0),
                    radius: 24, y: 10)
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isFocused)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Glassmorphism Card Modifiers
extension View {
    func glassCard(cornerRadius: CGFloat = 28) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.white.opacity(0.05))
                    .shadow(color: Color.black.opacity(0.18), radius: 18, x: 0, y: 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
            )
    }
}

// MARK: - Hex Color Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
