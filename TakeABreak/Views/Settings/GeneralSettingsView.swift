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
                    durationRow(
                        label: "Work duration",
                        value: $settings.configuration.workDurationMinutes,
                        range: 1...120,
                        unit: "min"
                    )

                    durationRow(
                        label: "Break duration",
                        value: $settings.configuration.breakDurationSeconds,
                        range: 5...300,
                        step: 5,
                        unit: "sec"
                    )

                    durationRow(
                        label: "Pre-break warning",
                        value: $settings.configuration.preBreakWarningSeconds,
                        range: 3...30,
                        unit: "sec"
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

    private func durationRow(
        label: String,
        value: Binding<Int>,
        range: ClosedRange<Int>,
        step: Int = 1,
        unit: String
    ) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField(
                "",
                value: value,
                format: .number
            )
            .frame(width: 50)
            .textFieldStyle(.roundedBorder)
            .multilineTextAlignment(.trailing)
            .onChange(of: value.wrappedValue) { _, newValue in
                value.wrappedValue = min(max(newValue, range.lowerBound), range.upperBound)
            }
            Text(unit)
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .leading)
            Stepper(
                "",
                value: value,
                in: range,
                step: step
            )
            .labelsHidden()
        }
    }
}
