import SwiftUI

struct QuickControlsView: View {
    @Bindable var timerVM: TimerViewModel

    var body: some View {
        HStack(spacing: 12) {
            if timerVM.isIdle {
                Button {
                    timerVM.start()
                } label: {
                    Label("Start", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
            } else {
                // Pause/Resume
                Button {
                    timerVM.togglePause()
                } label: {
                    Label(
                        timerVM.isPaused ? "Resume" : "Pause",
                        systemImage: timerVM.isPaused ? "play.fill" : "pause.fill"
                    )
                }
                .buttonStyle(.bordered)

                // Take break now
                if timerVM.isWorking {
                    Button {
                        timerVM.skipToBreak()
                    } label: {
                        Label("Break Now", systemImage: "forward.fill")
                    }
                    .buttonStyle(.bordered)
                }

                // Reset
                Button {
                    timerVM.reset()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
