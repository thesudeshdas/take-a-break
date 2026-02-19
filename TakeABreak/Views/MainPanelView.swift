import SwiftUI

struct MainPanelView: View {
    @Bindable var timerVM: TimerViewModel
    var onClose: () -> Void

    @State private var showingSettings = false

    var body: some View {
        Group {
            if showingSettings {
                SettingsView(timerVM: timerVM, showBack: true) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingSettings = false
                    }
                }
            } else {
                TimerControlView(timerVM: timerVM) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showingSettings = true
                    }
                } onClose: {
                    onClose()
                }
            }
        }
        .frame(width: 400, height: 460)
    }
}
