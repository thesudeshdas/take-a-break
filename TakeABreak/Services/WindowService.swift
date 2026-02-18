import AppKit
import SwiftUI

@Observable
@MainActor
final class PreBreakCountdown {
    var seconds: Int = 0
}

@MainActor
final class WindowService {
    private var breakPanels: [NSPanel] = []
    private var preBreakPanel: NSPanel?
    private var mouseMonitor: Any?
    private var localMouseMonitor: Any?
    private var countdownModel: PreBreakCountdown?

    func showBreakOverlay(timerViewModel: TimerViewModel) {
        dismissBreakOverlay()

        for screen in NSScreen.screens {
            let panel = createBreakPanel(for: screen, timerViewModel: timerViewModel)
            panel.alphaValue = 0
            panel.orderFrontRegardless()
            breakPanels.append(panel)
        }

        // Slow fade-in so the break screen isn't jarring
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 1.0
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            for panel in self.breakPanels {
                panel.animator().alphaValue = 1
            }
        }
    }

    private func createBreakPanel(
        for screen: NSScreen,
        timerViewModel: TimerViewModel
    ) -> NSPanel {
        let panel = NSPanel(
            contentRect: screen.frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        panel.level = .screenSaver
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.ignoresMouseEvents = false
        panel.isMovable = false

        // Blur effect so the user can see what they were working on
        let visualEffectView = NSVisualEffectView(frame: screen.frame)
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active
        visualEffectView.autoresizingMask = [.width, .height]
        visualEffectView.appearance = NSAppearance(named: .darkAqua)

        let hostingView = NSHostingView(
            rootView: BreakOverlayView(timerVM: timerViewModel)
                .background(Color.clear)
        )
        hostingView.frame = screen.frame
        hostingView.autoresizingMask = [.width, .height]
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = .clear

        // Hosting view must be a subview of the blur view so blur shows through
        visualEffectView.addSubview(hostingView)
        panel.contentView = visualEffectView

        return panel
    }

    func showPreBreakNotification(seconds: Int) {
        dismissPreBreakNotification()

        let countdown = PreBreakCountdown()
        countdown.seconds = seconds
        countdownModel = countdown

        let width: CGFloat = 320
        let height: CGFloat = 90

        let mouseLocation = NSEvent.mouseLocation
        let frame = preBreakPanelFrame(
            around: mouseLocation, width: width, height: height
        )

        let panel = NSPanel(
            contentRect: frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.ignoresMouseEvents = true
        panel.animationBehavior = .none

        let hostingView = NSHostingView(
            rootView: PreBreakNotificationView(countdown: countdown)
        )
        panel.contentView = hostingView
        panel.orderFrontRegardless()

        preBreakPanel = panel

        mouseMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.mouseMoved, .leftMouseDragged, .rightMouseDragged]
        ) { [weak self] _ in
            Task { @MainActor in self?.repositionPreBreakPanel() }
        }
        localMouseMonitor = NSEvent.addLocalMonitorForEvents(
            matching: [.mouseMoved, .leftMouseDragged, .rightMouseDragged]
        ) { [weak self] event in
            Task { @MainActor in self?.repositionPreBreakPanel() }
            return event
        }
    }

    func updatePreBreakCountdown(seconds: Int) {
        countdownModel?.seconds = seconds
    }

    private func repositionPreBreakPanel() {
        guard let panel = preBreakPanel else { return }
        let mouseLocation = NSEvent.mouseLocation
        let newFrame = preBreakPanelFrame(
            around: mouseLocation,
            width: panel.frame.width,
            height: panel.frame.height
        )
        panel.setFrame(newFrame, display: true, animate: false)
    }

    private func preBreakPanelFrame(
        around point: NSPoint, width: CGFloat, height: CGFloat
    ) -> NSRect {
        let offsetX: CGFloat = 20
        let offsetY: CGFloat = 20

        var x = point.x + offsetX
        var y = point.y + offsetY

        let screen = NSScreen.screens.first { $0.frame.contains(point) }
            ?? NSScreen.main
        if let visibleFrame = screen?.visibleFrame {
            if x + width > visibleFrame.maxX {
                x = point.x - width - offsetX
            }
            if y + height > visibleFrame.maxY {
                y = point.y - height - offsetY
            }
            x = max(visibleFrame.minX, min(x, visibleFrame.maxX - width))
            y = max(visibleFrame.minY, min(y, visibleFrame.maxY - height))
        }

        return NSRect(x: x, y: y, width: width, height: height)
    }

    func dismissBreakOverlay() {
        breakPanels.forEach { $0.close() }
        breakPanels.removeAll()
        dismissPreBreakNotification()
    }

    func dismissPreBreakNotification() {
        if let monitor = mouseMonitor {
            NSEvent.removeMonitor(monitor)
            mouseMonitor = nil
        }
        if let monitor = localMouseMonitor {
            NSEvent.removeMonitor(monitor)
            localMouseMonitor = nil
        }
        preBreakPanel?.close()
        preBreakPanel = nil
        countdownModel = nil
    }
}
