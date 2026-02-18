import SwiftUI

struct SettingsView: View {
    let timerVM: TimerViewModel

    var body: some View {
        TabView {
            GeneralSettingsView(timerVM: timerVM)
                .tabItem {
                    Label("General", systemImage: "gear")
                }

            SmartPauseSettingsView()
                .tabItem {
                    Label("Smart Pause", systemImage: "brain")
                }

            SoundsSettingsView()
                .tabItem {
                    Label("Sounds", systemImage: "speaker.wave.2")
                }

            AppearanceSettingsView()
                .tabItem {
                    Label("Appearance", systemImage: "paintbrush")
                }

            AboutSettingsView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 480, height: 360)
    }
}
