import SwiftUI

struct TimerControlView: View {
    @Bindable var timerVM: TimerViewModel
    var onSettings: () -> Void
    var onClose: () -> Void

    private var workDuration: TimeInterval {
        TimeInterval(timerVM.settings.configuration.workDurationMinutes * 60)
    }

    private var progress: Double {
        switch timerVM.phase {
        case .idle:
            return 0
        case .working(let remaining):
            guard workDuration > 0 else { return 0 }
            return 1.0 - (remaining / workDuration)
        case .preBreak:
            return 1.0
        case .paused(_, let remaining):
            guard workDuration > 0 else { return 0 }
            return 1.0 - (remaining / workDuration)
        case .onBreak:
            return 0
        }
    }

    private var ringColor: Color {
        switch timerVM.phase {
        case .idle: .secondary
        case .working: .accentColor
        case .preBreak: .orange
        case .paused: .secondary
        case .onBreak: .green
        }
    }

    private var displayTime: String {
        if timerVM.isIdle {
            return workDuration.formattedMinutesSeconds
        }
        return timerVM.remainingTime.formattedMinutesSeconds
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)

            Spacer(minLength: 0)

            // Progress ring
            progressRing
                .padding(.bottom, 8)

            // Status text
            Text(timerVM.statusText)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.bottom, 4)

            // Smart pause indicator
            smartPauseIndicator
                .padding(.bottom, 16)

            // Control buttons
            controls
                .padding(.bottom, 16)

            Spacer(minLength: 0)

            // Footer
            footer
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            if timerVM.completedBreaksToday > 0 {
                Label("\(timerVM.completedBreaksToday)", systemImage: "eye")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onSettings) {
                Image(systemName: "gear")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .buttonStyle(.plain)
            .padding(.leading, 8)
        }
    }

    // MARK: - Progress Ring

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(ringColor.opacity(0.15), lineWidth: 8)
                .frame(width: 180, height: 180)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    ringColor,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 180, height: 180)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.5), value: progress)

            Text(displayTime)
                .font(.system(size: 44, weight: .ultraLight, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())
                .opacity(timerVM.isPaused ? 0.5 : 1.0)
        }
    }

    // MARK: - Smart Pause Indicator

    @ViewBuilder
    private var smartPauseIndicator: some View {
        if !timerVM.smartPauseReasons.isEmpty {
            HStack(spacing: 4) {
                Image(systemName: "pause.circle.fill")
                    .foregroundStyle(.orange)
                Text(timerVM.smartPauseReasons.map(\.rawValue).joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Controls

    private var controls: some View {
        HStack(spacing: 12) {
            if timerVM.isIdle {
                Button {
                    timerVM.start()
                } label: {
                    Label("Start", systemImage: "play.fill")
                        .frame(minWidth: 80)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            } else {
                Button {
                    timerVM.togglePause()
                } label: {
                    Label(
                        timerVM.isPaused ? "Resume" : "Pause",
                        systemImage: timerVM.isPaused ? "play.fill" : "pause.fill"
                    )
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)

                if timerVM.isWorking {
                    Button {
                        timerVM.skipToBreak()
                    } label: {
                        Label("Break Now", systemImage: "forward.fill")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                }

                Button {
                    timerVM.reset()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
            }
        }
    }

    // MARK: - Footer

    private var footer: some View {
        HStack {
            Spacer()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 12))
            .foregroundStyle(.tertiary)
        }
    }
}
