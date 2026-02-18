import SwiftUI

struct SoundsSettingsView: View {
    @Bindable private var settings = SettingsManager.shared
    private let soundService = SoundService()

    var body: some View {
        Form {
            Section("Sound") {
                Toggle("Enable sounds", isOn: $settings.configuration.soundEnabled)
            }

            if settings.configuration.soundEnabled {
                Section("Break Start Sound") {
                    Picker("Sound", selection: $settings.configuration.breakStartSound) {
                        ForEach(BreakSoundType.allCases) { sound in
                            Text(sound.displayName).tag(sound)
                        }
                    }

                    Button("Preview") {
                        soundService.playSound(
                            settings.configuration.breakStartSound,
                            volume: settings.configuration.soundVolume,
                            enabled: true
                        )
                    }
                }

                Section("Break End Sound") {
                    Picker("Sound", selection: $settings.configuration.breakEndSound) {
                        ForEach(BreakSoundType.allCases) { sound in
                            Text(sound.displayName).tag(sound)
                        }
                    }

                    Button("Preview") {
                        soundService.playSound(
                            settings.configuration.breakEndSound,
                            volume: settings.configuration.soundVolume,
                            enabled: true
                        )
                    }
                }

                Section("Volume") {
                    Slider(value: $settings.configuration.soundVolume, in: 0...1) {
                        Text("Volume")
                    }
                }
            }
        }
        .formStyle(.grouped)
    }
}
