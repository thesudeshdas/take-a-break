import Foundation
import AppKit
import AVFoundation

final class SmartPauseService: Sendable {
    func monitorPauseReasons() -> AsyncStream<Set<SmartPauseReason>> {
        AsyncStream { continuation in
            let task = Task {
                while !Task.isCancelled {
                    var reasons: Set<SmartPauseReason> = []

                    if await self.isScreenBeingRecorded() {
                        reasons.insert(.screenRecording)
                    }
                    if self.isCameraInUse() {
                        reasons.insert(.videoCall)
                    }
                    if await self.isFullscreenAppActive() {
                        reasons.insert(.fullscreenApp)
                    }

                    continuation.yield(reasons)
                    try? await Task.sleep(for: .seconds(3))
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in task.cancel() }
        }
    }

    @MainActor
    private func isScreenBeingRecorded() -> Bool {
        // Only detect third-party recording apps that are actively in the foreground.
        // Apple's screencaptureui/screencapture.interactive run as background
        // system processes at all times, so we skip those to avoid false positives.
        let recordingBundleIDs: Set<String> = [
            "com.loom.desktop",
            "com.getcleanshot.app",
            "com.obsproject.obs-studio",
            "com.screenflow.app",
        ]

        let runningApps = NSWorkspace.shared.runningApplications
        for app in runningApps {
            if let bundleID = app.bundleIdentifier,
               recordingBundleIDs.contains(bundleID),
               !app.isHidden {
                return true
            }
        }

        // Check for QuickTime Player only if it's actively recording (foreground)
        for app in runningApps {
            if app.bundleIdentifier == "com.apple.QuickTimePlayerX",
               app.isActive {
                return true
            }
        }

        return false
    }

    private func isCameraInUse() -> Bool {
        let devices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .external],
            mediaType: .video,
            position: .unspecified
        ).devices

        for device in devices {
            if device.isInUseByAnotherApplication {
                return true
            }
        }
        return false
    }

    @MainActor
    private func isFullscreenAppActive() -> Bool {
        guard let frontmostApp = NSWorkspace.shared.frontmostApplication else {
            return false
        }
        // Check if the frontmost app's windows cover the entire screen
        let options: CGWindowListOption = [.optionOnScreenOnly, .excludeDesktopElements]
        guard let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
            return false
        }

        guard let mainScreen = NSScreen.main else { return false }
        let screenFrame = mainScreen.frame

        for window in windowList {
            guard let ownerPID = window[kCGWindowOwnerPID as String] as? Int32,
                  ownerPID == frontmostApp.processIdentifier,
                  let boundsDict = window[kCGWindowBounds as String] as? [String: CGFloat] else {
                continue
            }

            let windowWidth = boundsDict["Width"] ?? 0
            let windowHeight = boundsDict["Height"] ?? 0

            if windowWidth >= screenFrame.width && windowHeight >= screenFrame.height {
                return true
            }
        }
        return false
    }
}
