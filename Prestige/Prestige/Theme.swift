import SwiftUI

struct PrestigeTheme {
    // MARK: - Color Palette
    static let colors = ColorPalette()
    static let fonts = FontTheme()
    static let spacing = SpacingTheme()
    static let buttonStyle = ButtonStyles()
}

struct ColorPalette {
    let primary = Color(hex: "11100F")      // Black - Primary actions, text
    let secondary = Color(hex: "5D1C34")    // Burgundy - Secondary actions
    let accent = Color(hex: "A67D44")       // Gold - Accents, highlights
    let sage = Color(hex: "899481")         // Sage - Success states, verified badges
    let taupe = Color(hex: "CDBCAB")        // Taupe - Backgrounds, cards
    let cream = Color(hex: "EFE9E1")        // Cream - Light backgrounds
    
    // Functional colors
    let background = Color(hex: "EFE9E1")   // Cream background
    let cardBackground = Color(hex: "FFFFFF") // White for cards
    let textPrimary = Color(hex: "11100F")  // Black text
    let textSecondary = Color(hex: "5D1C34") // Burgundy text
    let border = Color(hex: "CDBCAB")       // Taupe borders
}

struct FontTheme {
    // Modern dating app typography
    let largeTitle = Font.custom("Optima-Bold", size: 32)
    let title = Font.custom("Optima-Bold", size: 24)
    let headline = Font.custom("Optima-Regular", size: 20)
    let body = Font.custom("Optima-Regular", size: 16)
    let caption = Font.custom("Optima-Regular", size: 14)
    
    // Fallback system fonts
    let systemLargeTitle = Font.system(size: 32, weight: .bold)
    let systemTitle = Font.system(size: 24, weight: .bold)
    let systemHeadline = Font.system(size: 20, weight: .semibold)
    let systemBody = Font.system(size: 16, weight: .regular)
    let systemCaption = Font.system(size: 14, weight: .regular)
}

struct SpacingTheme {
    let paddingSmall: CGFloat = 8
    let paddingMedium: CGFloat = 16
    let paddingLarge: CGFloat = 24
    let cornerRadius: CGFloat = 12
}

struct ButtonStyles {
    // Primary button style
    func primaryButton(title: String) -> some View {
        Text(title)
            .font(PrestigeTheme.fonts.systemHeadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(PrestigeTheme.colors.primary)
            .cornerRadius(PrestigeTheme.spacing.cornerRadius)
    }
    
    // Secondary button style
    func secondaryButton(title: String) -> some View {
        Text(title)
            .font(PrestigeTheme.fonts.systemHeadline)
            .foregroundColor(PrestigeTheme.colors.secondary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(PrestigeTheme.colors.background)
            .cornerRadius(PrestigeTheme.spacing.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: PrestigeTheme.spacing.cornerRadius)
                    .stroke(PrestigeTheme.colors.secondary, lineWidth: 1)
            )
    }
}

// Helper for hex color initialization
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
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 