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
                        // Simulated desktop background
                        simulatedDesktop
                            .blur(radius: settings.configuration.blurRadius)

                        // Gradient overlay with configurable opacity
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: theme.colors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .opacity(settings.configuration.overlayOpacity)

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

            Section("Overlay") {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Opacity")
                        Spacer()
                        Text("\(Int(settings.configuration.overlayOpacity * 100))%")
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $settings.configuration.overlayOpacity, in: 0.0...1.0)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Blur")
                        Spacer()
                        Text("\(Int(settings.configuration.blurRadius)) px")
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $settings.configuration.blurRadius, in: 0...30)
                }
            }

            Section("Messages") {
                TextField("Break message", text: $settings.configuration.customMessage)
                Toggle("Show motivational quotes", isOn: $settings.configuration.showMotivationalQuotes)
            }
        }
        .formStyle(.grouped)
    }

    /// A grid of SF Symbol icons simulating desktop app windows
    private var simulatedDesktop: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5),
                spacing: 12
            ) {
                ForEach(desktopIcons, id: \.self) { icon in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(nsColor: .controlBackgroundColor))
                        .frame(height: 36)
                        .overlay(
                            Image(systemName: icon)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        )
                }
            }
            .padding(12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var desktopIcons: [String] {
        [
            "doc.text", "folder", "globe", "envelope", "calendar",
            "photo", "music.note", "terminal", "gear", "map",
            "chart.bar", "book", "paintbrush", "cpu", "externaldrive",
            "printer", "wifi", "lock.shield", "person.crop.circle", "bell",
            "clock", "magnifyingglass", "paperplane", "bookmark", "star"
        ]
    }
}
