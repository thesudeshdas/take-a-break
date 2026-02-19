import SwiftUI

struct SettingsView: View {
    let timerVM: TimerViewModel
    var showBack: Bool = false
    var onBack: (() -> Void)? = nil

    @State private var selectedTab: SettingsTab = .general

    private enum SettingsTab: String, CaseIterable {
        case general, smartPause, sounds, appearance, about

        var label: String {
            switch self {
            case .general: "General"
            case .smartPause: "Smart Pause"
            case .sounds: "Sounds"
            case .appearance: "Appearance"
            case .about: "About"
            }
        }

        var icon: String {
            switch self {
            case .general: "gear"
            case .smartPause: "brain"
            case .sounds: "speaker.wave.2"
            case .appearance: "paintbrush"
            case .about: "info.circle"
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if showBack {
                HStack {
                    Button {
                        onBack?()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)

                    Spacer()

                    Text("Settings")
                        .font(.headline)

                    Spacer()

                    // Invisible spacer to balance the back button
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)
            }

            // Custom compact tab bar
            HStack(spacing: 2) {
                ForEach(SettingsTab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 13))
                            Text(tab.label)
                                .font(.system(size: 9, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(selectedTab == tab ? Color.accentColor.opacity(0.15) : Color.clear)
                        )
                        .foregroundStyle(selectedTab == tab ? .primary : .secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 4)

            // Tab content
            Group {
                switch selectedTab {
                case .general:
                    GeneralSettingsView(timerVM: timerVM)
                case .smartPause:
                    SmartPauseSettingsView()
                case .sounds:
                    SoundsSettingsView()
                case .appearance:
                    AppearanceSettingsView()
                case .about:
                    AboutSettingsView()
                }
            }
        }
    }
}
