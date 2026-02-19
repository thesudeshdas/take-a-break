import AppKit
import SwiftUI

// MARK: - FloatingPanel

final class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool { true }

    override func cancelOperation(_ sender: Any?) {
        orderOut(nil)
    }
}

// MARK: - AppDelegate

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var panel: FloatingPanel!
    let timerVM = TimerViewModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        setupPanel()
        observeMenuBar()
    }

    // MARK: - Status Item

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "eye", accessibilityDescription: "Take a Break")
            button.target = self
            button.action = #selector(statusItemClicked)
        }
    }

    @objc private func statusItemClicked() {
        if panel.isVisible {
            panel.orderOut(nil)
        } else {
            showPanel()
        }
    }

    // MARK: - Panel

    private func setupPanel() {
        let contentRect = NSRect(x: 0, y: 0, width: 400, height: 460)
        panel = FloatingPanel(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.animationBehavior = .utilityWindow
        panel.isReleasedWhenClosed = false
        panel.hidesOnDeactivate = false

        let hostView = NSHostingView(
            rootView: MainPanelView(timerVM: timerVM) { [weak self] in
                self?.panel.orderOut(nil)
            }
            .background(VisualEffectBackground())
        )
        hostView.wantsLayer = true
        hostView.layer?.cornerRadius = 12
        hostView.layer?.masksToBounds = true

        panel.contentView = hostView
    }

    private func showPanel() {
        let screen = NSScreen.screens.first(where: { NSMouseInRect(NSEvent.mouseLocation, $0.frame, false) })
            ?? NSScreen.main
            ?? NSScreen.screens[0]
        let screenFrame = screen.visibleFrame
        let panelSize = panel.frame.size
        let x = screenFrame.midX - panelSize.width / 2
        let y = screenFrame.midY - panelSize.height / 2 + screenFrame.height * 0.1
        panel.setFrameOrigin(NSPoint(x: x, y: y))
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    // MARK: - Menu Bar Observation

    private func observeMenuBar() {
        withObservationTracking {
            _ = timerVM.menuBarIcon
            _ = timerVM.menuBarText
        } onChange: { [weak self] in
            Task { @MainActor [weak self] in
                self?.updateStatusItemDisplay()
                self?.observeMenuBar()
            }
        }
        updateStatusItemDisplay()
    }

    private func updateStatusItemDisplay() {
        guard let button = statusItem.button else { return }
        button.image = NSImage(
            systemSymbolName: timerVM.menuBarIcon,
            accessibilityDescription: "Take a Break"
        )
        let text = timerVM.menuBarText
        button.title = text.isEmpty ? "" : " \(text)"
        button.imagePosition = text.isEmpty ? .imageOnly : .imageLeading
    }
}

// MARK: - Visual Effect Background

struct VisualEffectBackground: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .popover
        view.blendingMode = .behindWindow
        view.state = .active
        view.wantsLayer = true
        view.layer?.cornerRadius = 12
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
