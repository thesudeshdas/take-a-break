import SwiftUI

@main
struct TakeABreakApp: App {
    @State private var timerVM = TimerViewModel()

    var body: some Scene {
        MenuBarExtra("Take a Break", systemImage: "eye") {
            MenuBarView(timerVM: timerVM)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView(timerVM: timerVM)
        }
    }
}
