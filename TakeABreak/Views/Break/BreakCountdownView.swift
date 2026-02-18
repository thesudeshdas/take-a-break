import SwiftUI

struct BreakCountdownView: View {
    let remaining: TimeInterval
    let total: TimeInterval
    let textColor: Color

    private var progress: Double {
        guard total > 0 else { return 0 }
        return 1.0 - (remaining / total)
    }

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(textColor.opacity(0.15), lineWidth: 6)
                .frame(width: 200, height: 200)

            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    textColor.opacity(0.9),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.5), value: progress)

            // Time text
            Text(Int(remaining).formatted())
                .font(.system(size: 56, weight: .ultraLight, design: .rounded))
                .foregroundStyle(textColor)
                .monospacedDigit()
                .contentTransition(.numericText())
        }
    }
}

private extension Int {
    func formatted() -> String {
        if self >= 60 {
            let minutes = self / 60
            let seconds = self % 60
            return String(format: "%d:%02d", minutes, seconds)
        }
        return "\(self)"
    }
}
