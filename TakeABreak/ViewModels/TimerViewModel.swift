import Foundation
import Observation
import AppKit

@Observable
@MainActor
final class TimerViewModel {
    // MARK: - Published State
    private(set) var phase: TimerPhase = .idle
    private(set) var smartPauseReasons: Set<SmartPauseReason> = []
    private(set) var completedBreaksToday: Int = 0

    // MARK: - Dependencies
    let settings = SettingsManager.shared
    private let smartPauseService = SmartPauseService()
    private let soundService = SoundService()
    let windowService = WindowService()

    // MARK: - Internal
    private var timerTask: Task<Void, Never>?
    private var smartPauseTask: Task<Void, Never>?
    private var targetDate: Date?

    // MARK: - Computed
    var isPaused: Bool {
        if case .paused = phase { return true }
        return false
    }

    var isWorking: Bool {
        if case .working = phase { return true }
        return false
    }

    var isIdle: Bool {
        if case .idle = phase { return true }
        return false
    }

    var isOnBreak: Bool {
        if case .onBreak = phase { return true }
        return false
    }

    var remainingTime: TimeInterval {
        switch phase {
        case .idle: return 0
        case .working(let r): return r
        case .preBreak(let r): return r
        case .onBreak(let r): return r
        case .paused(_, let r): return r
        }
    }

    var statusText: String {
        switch phase {
        case .idle:
            return "Ready"
        case .working:
            return "Working"
        case .preBreak:
            return "Break starting..."
        case .onBreak:
            return "On Break"
        case .paused(_, _):
            if !smartPauseReasons.isEmpty {
                return "Auto-paused"
            }
            return "Paused"
        }
    }

    var menuBarIcon: String {
        switch phase {
        case .idle: "eye"
        case .working: "eye"
        case .preBreak: "bell.badge"
        case .onBreak: "eye.slash"
        case .paused: "pause.circle"
        }
    }

    var menuBarText: String {
        switch phase {
        case .idle: ""
        case .working(let r): r.formattedMenuBar
        case .preBreak(let r): r.formattedMenuBar
        case .onBreak(let r): "\(Int(r))s"
        case .paused: ""
        }
    }

    init() {
        startSmartPauseMonitoring()
    }

    // MARK: - Public API

    func start() {
        let workDuration = TimeInterval(settings.configuration.workDurationMinutes * 60)
        phase = .working(remaining: workDuration)
        startWorkTimer(duration: workDuration)
    }

    func togglePause() {
        switch phase {
        case .working(let remaining):
            timerTask?.cancel()
            phase = .paused(previousPhase: .manual, remaining: remaining)
        case .preBreak(let remaining):
            timerTask?.cancel()
            windowService.dismissPreBreakNotification()
            phase = .paused(previousPhase: .manual, remaining: remaining)
        case .paused(_, let remaining):
            phase = .working(remaining: remaining)
            startWorkTimer(duration: remaining)
        default:
            break
        }
    }

    func skipToBreak() {
        timerTask?.cancel()
        beginBreak()
    }

    func endBreakEarly() {
        timerTask?.cancel()
        windowService.dismissBreakOverlay()
        completedBreaksToday += 1
        start()
    }

    func postponeBreak(byMinutes: Int) {
        timerTask?.cancel()
        windowService.dismissBreakOverlay()
        windowService.dismissPreBreakNotification()
        let extra = TimeInterval(byMinutes * 60)
        phase = .working(remaining: extra)
        startWorkTimer(duration: extra)
    }

    func reset() {
        timerTask?.cancel()
        windowService.dismissBreakOverlay()
        windowService.dismissPreBreakNotification()
        phase = .idle
    }

    // MARK: - Private Timer Logic

    private func startWorkTimer(duration: TimeInterval) {
        timerTask?.cancel()
        let target = Date.now.addingTimeInterval(duration)
        targetDate = target
        let warningSeconds = TimeInterval(settings.configuration.preBreakWarningSeconds)

        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.5))
                guard !Task.isCancelled, let self else { return }

                let remaining = target.timeIntervalSince(Date.now)

                if remaining <= 0 {
                    self.beginBreak()
                    return
                }

                if remaining <= warningSeconds {
                    if case .working = self.phase {
                        self.beginPreBreak(remaining: remaining)
                        return
                    }
                }

                self.phase = .working(remaining: max(0, remaining))
            }
        }
    }

    private func beginPreBreak(remaining: TimeInterval) {
        phase = .preBreak(remaining: remaining)
        windowService.showPreBreakNotification(seconds: Int(remaining))

        timerTask?.cancel()
        let target = Date.now.addingTimeInterval(remaining)

        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.5))
                guard !Task.isCancelled, let self else { return }

                let r = target.timeIntervalSince(Date.now)

                if r <= 0 {
                    self.windowService.dismissPreBreakNotification()
                    self.beginBreak()
                    return
                }

                self.phase = .preBreak(remaining: max(0, r))
                self.windowService.updatePreBreakCountdown(seconds: Int(max(0, r)))
            }
        }
    }

    private func beginBreak() {
        let breakDuration = TimeInterval(settings.configuration.breakDurationSeconds)
        phase = .onBreak(remaining: breakDuration)

        soundService.playSound(settings.configuration.breakStartSound,
                               volume: settings.configuration.soundVolume,
                               enabled: settings.configuration.soundEnabled)
        windowService.showBreakOverlay(timerViewModel: self)

        timerTask?.cancel()
        let target = Date.now.addingTimeInterval(breakDuration)

        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.5))
                guard !Task.isCancelled, let self else { return }

                let r = target.timeIntervalSince(Date.now)

                if r <= 0 {
                    self.soundService.playSound(
                        self.settings.configuration.breakEndSound,
                        volume: self.settings.configuration.soundVolume,
                        enabled: self.settings.configuration.soundEnabled
                    )
                    self.windowService.dismissBreakOverlay()
                    self.completedBreaksToday += 1
                    self.start()
                    return
                }

                self.phase = .onBreak(remaining: max(0, r))
            }
        }
    }

    // MARK: - Smart Pause

    private func startSmartPauseMonitoring() {
        smartPauseTask = Task { [weak self] in
            guard let self else { return }

            for await reasons in self.smartPauseService.monitorPauseReasons() {
                guard !Task.isCancelled else { return }

                let config = self.settings.configuration
                var activeReasons: Set<SmartPauseReason> = []

                if config.pauseDuringScreenRecording && reasons.contains(.screenRecording) {
                    activeReasons.insert(.screenRecording)
                }
                if config.pauseDuringVideoCalls && reasons.contains(.videoCall) {
                    activeReasons.insert(.videoCall)
                }
                if config.pauseDuringFullscreen && reasons.contains(.fullscreenApp) {
                    activeReasons.insert(.fullscreenApp)
                }

                self.smartPauseReasons = activeReasons

                if !activeReasons.isEmpty && self.isWorking {
                    if case .working(let remaining) = self.phase {
                        self.timerTask?.cancel()
                        self.phase = .paused(previousPhase: .working, remaining: remaining)
                    }
                } else if activeReasons.isEmpty {
                    if case .paused(.working, let remaining) = self.phase {
                        self.phase = .working(remaining: remaining)
                        self.startWorkTimer(duration: remaining)
                    }
                }
            }
        }
    }
}
