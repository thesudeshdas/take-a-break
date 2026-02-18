import SwiftUI

enum BreakBackgroundType: String, Codable, CaseIterable, Identifiable {
    case gradientBlue
    case gradientGreen
    case gradientSunset
    case gradientPurple
    case darkBlur
    case minimal

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .gradientBlue: "Ocean Blue"
        case .gradientGreen: "Forest Green"
        case .gradientSunset: "Warm Sunset"
        case .gradientPurple: "Deep Purple"
        case .darkBlur: "Dark"
        case .minimal: "Minimal"
        }
    }

    var colors: [Color] {
        switch self {
        case .gradientBlue:
            [Color(red: 0.1, green: 0.3, blue: 0.7), Color(red: 0.2, green: 0.6, blue: 0.9)]
        case .gradientGreen:
            [Color(red: 0.1, green: 0.5, blue: 0.3), Color(red: 0.2, green: 0.7, blue: 0.5)]
        case .gradientSunset:
            [Color(red: 0.9, green: 0.4, blue: 0.2), Color(red: 0.95, green: 0.6, blue: 0.3)]
        case .gradientPurple:
            [Color(red: 0.3, green: 0.1, blue: 0.6), Color(red: 0.5, green: 0.2, blue: 0.8)]
        case .darkBlur:
            [Color(white: 0.1), Color(white: 0.15)]
        case .minimal:
            [Color(white: 0.95), Color(white: 0.9)]
        }
    }

    var textColor: Color {
        self == .minimal ? .primary : .white
    }

    @ViewBuilder
    var view: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
