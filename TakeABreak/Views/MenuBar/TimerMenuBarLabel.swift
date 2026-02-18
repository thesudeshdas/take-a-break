import SwiftUI

struct TimerMenuBarLabel: View {
    let timerVM: TimerViewModel

    var body: some View {
        Label(timerVM.menuBarText, systemImage: timerVM.menuBarIcon)
            .labelStyle(.titleAndIcon)
    }
}
