import SwiftUI

struct AppearanceSettingsView: View {
    @Bindable private var settings = SettingsManager.shared

    private var theme: BreakBackgroundType {
        settings.configuration.breakBackground
    }

    var body: some View {
        Form {
            Section("Preview") {
                VStack {
                    ZStack {
                        // Background
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: theme.colors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        VStack(spacing: 16) {
                            // Countdown ring preview
                            BreakCountdownView(
                                remaining: 15,
                                total: 20,
                                textColor: theme.textColor
                            )
                            .scaleEffect(0.5)
                            .frame(height: 100)

                            // Message preview
                            BreakMessageView(
                                message: settings.configuration.customMessage.isEmpty
                                    ? "Look at something 20 feet away"
                                    : settings.configuration.customMessage,
                                showQuotes: settings.configuration.showMotivationalQuotes,
                                textColor: theme.textColor
                            )
                            .scaleEffect(0.7)
                            .frame(height: 50)
                        }
                        .padding(.vertical, 12)
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            Section("Break Background") {
                Picker("Theme", selection: $settings.configuration.breakBackground) {
                    ForEach(BreakBackgroundType.allCases) { bg in
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: bg.colors,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 24, height: 16)
                            Text(bg.displayName)
                        }
                        .tag(bg)
                    }
                }
            }

            Section("Messages") {
                TextField("Break message", text: $settings.configuration.customMessage)
                Toggle("Show motivational quotes", isOn: $settings.configuration.showMotivationalQuotes)
            }
        }
        .formStyle(.grouped)
    }
}
