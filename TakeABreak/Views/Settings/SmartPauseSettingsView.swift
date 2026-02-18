import SwiftUI

struct SmartPauseSettingsView: View {
    @Bindable private var settings = SettingsManager.shared

    var body: some View {
        Form {
            Section("Automatically pause during") {
                Toggle(isOn: $settings.configuration.pauseDuringScreenRecording) {
                    Label {
                        VStack(alignment: .leading) {
                            Text("Screen Recording")
                            Text("QuickTime, Loom, CleanShot, OBS")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "record.circle")
                    }
                }

                Toggle(isOn: $settings.configuration.pauseDuringVideoCalls) {
                    Label {
                        VStack(alignment: .leading) {
                            Text("Video Calls")
                            Text("Detects when camera is in use")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "video.fill")
                    }
                }

                Toggle(isOn: $settings.configuration.pauseDuringFullscreen) {
                    Label {
                        VStack(alignment: .leading) {
                            Text("Fullscreen Apps")
                            Text("Games, presentations, videos")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                    }
                }
            }

            Section {
                Text("When detected, the break timer will pause automatically and resume when the activity ends.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
    }
}
