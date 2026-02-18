import SwiftUI

struct GeneralSettingsView: View {
    let timerVM: TimerViewModel
    @Bindable private var settings = SettingsManager.shared

    var body: some View {
        Form {
            Section("Break Schedule") {
                Toggle("Use 20-20-20 Rule", isOn: $settings.configuration.use202020Rule)
                    .onChange(of: settings.configuration.use202020Rule) { _, newValue in
                        if newValue {
                            settings.configuration.apply2020Rule()
                        }
                    }

                if !settings.configuration.use202020Rule {
                    Stepper(
                        "Work duration: \(settings.configuration.workDurationMinutes) min",
                        value: $settings.configuration.workDurationMinutes,
                        in: 1...120
                    )

                    Stepper(
                        "Break duration: \(settings.configuration.breakDurationSeconds) sec",
                        value: $settings.configuration.breakDurationSeconds,
                        in: 5...300,
                        step: 5
                    )

                    Stepper(
                        "Pre-break warning: \(settings.configuration.preBreakWarningSeconds) sec",
                        value: $settings.configuration.preBreakWarningSeconds,
                        in: 3...30
                    )
                }
            }

            Section("Behavior") {
                Toggle("Strict mode (no skip/postpone)", isOn: $settings.configuration.strictMode)

                Toggle("Launch at login", isOn: Binding(
                    get: { LaunchAtLoginService.isEnabled },
                    set: { LaunchAtLoginService.setEnabled($0) }
                ))
            }

            Section {
                Button("Reset to Defaults") {
                    settings.resetToDefaults()
                    timerVM.reset()
                }
            }
        }
        .formStyle(.grouped)
    }
}
