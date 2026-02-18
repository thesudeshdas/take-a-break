import Foundation

enum TimerPhase: Equatable {
    case idle
    case working(remaining: TimeInterval)
    case preBreak(remaining: TimeInterval)
    case onBreak(remaining: TimeInterval)
    case paused(previousPhase: PausedFrom, remaining: TimeInterval)
}

enum PausedFrom: Equatable {
    case working
    case manual
}

enum SmartPauseReason: String, CaseIterable, Identifiable {
    case screenRecording = "Screen Recording"
    case videoCall = "Video Call"
    case fullscreenApp = "Fullscreen App"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .screenRecording: "record.circle"
        case .videoCall: "video.fill"
        case .fullscreenApp: "arrow.up.left.and.arrow.down.right"
        }
    }
}
