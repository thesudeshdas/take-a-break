import SwiftUI

struct AppearanceSettingsView: View {
    @Bindable private var settings = SettingsManager.shared

    var body: some View {
        Form {
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
