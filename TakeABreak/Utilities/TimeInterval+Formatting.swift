import Foundation

extension TimeInterval {
    /// Formats as "14:32" for menu bar popover display
    var formattedMinutesSeconds: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    /// Formats as "14:32" for menu bar label (compact)
    var formattedMenuBar: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    /// Formats as "20s" for short break countdown
    var formattedSeconds: String {
        "\(Int(self))s"
    }
}
