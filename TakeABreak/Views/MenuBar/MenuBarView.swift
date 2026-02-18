import SwiftUI

struct MenuBarView: View {
    @Bindable var timerVM: TimerViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Status section
            VStack(spacing: 8) {
                HStack {
                    Text(timerVM.statusText)
                        .font(.headline)
                    Spacer()
                    if timerVM.completedBreaksToday > 0 {
                        Label("\(timerVM.completedBreaksToday)", systemImage: "eye")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if !timerVM.isIdle {
                    Text(timerVM.remainingTime.formattedMinutesSeconds)
                        .font(.system(size: 36, weight: .light, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                }

                // Smart pause indicator
                if !timerVM.smartPauseReasons.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "pause.circle.fill")
                            .foregroundStyle(.orange)
                        Text("Paused: \(timerVM.smartPauseReasons.map(\.rawValue).joined(separator: ", "))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()

            Divider()

            // Controls
            QuickControlsView(timerVM: timerVM)
                .padding(.horizontal)
                .padding(.vertical, 8)

            Divider()

            // Footer
            HStack {
                SettingsLink {
                    Label("Settings...", systemImage: "gear")
                }
                .buttonStyle(.borderless)

                Spacer()

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(width: 280)
    }
}
