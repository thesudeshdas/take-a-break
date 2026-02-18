import SwiftUI

struct BreakMessageView: View {
    let message: String
    let showQuotes: Bool
    let textColor: Color

    private static let quotes = [
        "Your eyes deserve a rest.",
        "Look at something far away and relax.",
        "A short break boosts your focus.",
        "Take a deep breath and look away.",
        "Rest your eyes, refresh your mind.",
        "Step back, breathe, and recharge.",
        "Give your eyes the break they need.",
        "A moment of rest goes a long way.",
    ]

    private var displayMessage: String {
        if showQuotes {
            return Self.quotes.randomElement() ?? message
        }
        return message
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(message)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundStyle(textColor)
                .multilineTextAlignment(.center)

            if showQuotes {
                Text(Self.quotes.randomElement() ?? "")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(textColor.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 40)
    }
}
