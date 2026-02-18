import Foundation

struct BreakConfiguration: Codable, Equatable {
    // Work interval
    var workDurationMinutes: Int = 20
    // Break interval
    var breakDurationSeconds: Int = 20
    // Pre-break warning (seconds before break)
    var preBreakWarningSeconds: Int = 10
    // Whether to use 20-20-20 rule preset
    var use202020Rule: Bool = true

    // Smart pause toggles
    var pauseDuringScreenRecording: Bool = true
    var pauseDuringVideoCalls: Bool = true
    var pauseDuringFullscreen: Bool = true

    // Sound
    var breakStartSound: BreakSoundType = .chime
    var breakEndSound: BreakSoundType = .bell
    var soundVolume: Double = 0.7
    var soundEnabled: Bool = true

    // Appearance
    var breakBackground: BreakBackgroundType = .gradientBlue
    var customMessage: String = "Look at something 20 feet away"
    var showMotivationalQuotes: Bool = true

    // Behavior
    var launchAtLogin: Bool = false
    var strictMode: Bool = false

    mutating func apply2020Rule() {
        workDurationMinutes = 20
        breakDurationSeconds = 20
        preBreakWarningSeconds = 10
        customMessage = "Look at something 20 feet away"
        use202020Rule = true
    }
}
