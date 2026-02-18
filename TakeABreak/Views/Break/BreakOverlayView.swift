import SwiftUI

struct BreakOverlayView: View {
    @Bindable var timerVM: TimerViewModel
    private var settings: SettingsManager { timerVM.settings }

    private var remaining: TimeInterval {
        if case .onBreak(let r) = timerVM.phase { return r }
        return 0
    }

    var body: some View {
        ZStack {
            settings.configuration.breakBackground.view
                .opacity(settings.configuration.overlayOpacity)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                BreakCountdownView(
                    remaining: remaining,
                    total: TimeInterval(settings.configuration.breakDurationSeconds),
                    textColor: settings.configuration.breakBackground.textColor
                )

                BreakMessageView(
                    message: settings.configuration.customMessage,
                    showQuotes: settings.configuration.showMotivationalQuotes,
                    textColor: settings.configuration.breakBackground.textColor
                )

                if !settings.configuration.strictMode {
                    HStack(spacing: 16) {
                        Button("+1 min") {
                            timerVM.postponeBreak(byMinutes: 1)
                        }
                        .buttonStyle(BreakButtonStyle())

                        Button("+5 min") {
                            timerVM.postponeBreak(byMinutes: 5)
                        }
                        .buttonStyle(BreakButtonStyle())

                        Button("End Break") {
                            timerVM.endBreakEarly()
                        }
                        .buttonStyle(BreakPrimaryButtonStyle())
                    }
                }

                Spacer()
            }
        }
    }
}

struct BreakButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.white.opacity(configuration.isPressed ? 0.3 : 0.2))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct BreakPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(.white.opacity(configuration.isPressed ? 0.9 : 0.8))
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
