# Take a Break

A native macOS menu bar application that helps protect your eyes using the **20-20-20 rule** — every 20 minutes, take a 20-second break and look at something 20 feet away.

Built with SwiftUI. No third-party dependencies. Runs quietly in your menu bar.

Take a Break is a lightweight, zero-dependency macOS menu bar app for the 20-20-20 rule. It stays simple and out of your way.

## Features

### Core Timer
- Configurable work intervals (1–120 minutes, default: 20)
- Configurable break durations (5–300 seconds, default: 20)
- Pre-break warning notification before each break
- Break counter tracking completed breaks for the day
- Postpone breaks by 1 or 5 minutes
- Skip to break immediately or end breaks early

### Smart Pause
Automatically pauses reminders when you shouldn't be interrupted:
- **Screen Recording** — detects Loom, OBS Studio, CleanShot, ScreenFlow, QuickTime
- **Video Calls** — detects active camera usage (Zoom, Meet, FaceTime, etc.)
- **Fullscreen Apps** — detects fullscreen windows (presentations, games)

Resumes automatically when the condition ends.

### Break Overlay
- Full-screen overlay displayed on **all connected monitors** simultaneously
- Circular countdown progress ring
- Customizable break message
- Random motivational quotes
- Strict mode disables skip/postpone controls

### Appearance
Six visual themes for the break overlay:
- Ocean Blue, Forest Green, Warm Sunset, Deep Purple, Dark, Minimal
- Adjustable overlay opacity (0–100%)
- Adjustable blur intensity (0–30 px)
- Live preview in settings with simulated desktop background

### Sounds
- Separate start/end break sounds (Chime, Bell, Nature Birds, Water, or silent)
- Adjustable volume with preview

### System Integration
- Runs as a menu bar app (hidden from Dock)
- Launch at login support
- Hardened runtime enabled

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15+ with Swift 5.9
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (for project generation)

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/thesudeshdas/take-a-break.git
cd take-a-break
```

### 2. Generate the Xcode project

```bash
xcodegen generate
```

### 3. Open and run

```bash
open TakeABreak.xcodeproj
```

Build and run (`Cmd+R`) in Xcode. The app appears in your menu bar with an eye icon.

## Project Structure

```
TakeABreak/
├── TakeABreakApp.swift          # App entry point (MenuBarExtra + Settings)
├── AppDelegate.swift               # Menu bar setup, floating panel management
├── Info.plist                   # LSUIElement, camera usage description
├── TakeABreak.entitlements      # Hardened runtime entitlements
│
├── Models/
│   ├── AppState.swift           # TimerPhase, PausedFrom, SmartPauseReason enums
│   ├── BreakConfiguration.swift # All user-configurable settings
│   ├── BreakSound.swift         # Sound type enum with system sound mapping
│   └── BreakBackground.swift    # Theme enum with colors and gradients
│
├── ViewModels/
│   ├── TimerViewModel.swift     # Core state machine and timer logic
│   └── SettingsManager.swift    # UserDefaults persistence (singleton)
│
├── Views/
│   ├── MainPanelView.swift             # Floating panel main view
│   ├── TimerControlView.swift          # Timer display and controls
│   ├── Break/
│   │   ├── BreakOverlayView.swift      # Full-screen break UI
│   │   ├── BreakCountdownView.swift    # Circular progress ring
│   │   ├── BreakMessageView.swift      # Message + motivational quotes
│   │   └── PreBreakNotificationView.swift # Floating pre-break warning
│   └── Settings/
│       ├── SettingsView.swift           # Tab container
│       ├── GeneralSettingsView.swift    # Durations, strict mode, launch at login
│       ├── SmartPauseSettingsView.swift # Smart pause toggles
│       ├── SoundsSettingsView.swift     # Sound selection and volume
│       ├── AppearanceSettingsView.swift # Themes and messages
│       └── AboutSettingsView.swift      # App info and version
│
├── Services/
│   ├── SmartPauseService.swift   # System monitoring (recording, camera, fullscreen)
│   ├── SoundService.swift        # NSSound playback
│   ├── WindowService.swift       # NSPanel management for overlays
│   ├── NotificationService.swift # System notification support
│   └── LaunchAtLoginService.swift # ServiceManagement integration
│
├── Utilities/
│   ├── Constants.swift               # App-wide constants
│   └── TimeInterval+Formatting.swift # Time formatting extensions
│
└── Resources/
    └── Assets.xcassets/          # App icon and accent color
```

## Architecture

The app follows **MVVM with a Service Layer**:

- **Models** define data structures and enums (no logic)
- **ViewModels** manage state using Swift 5.9 `@Observable` macro
- **Views** are pure SwiftUI with `@Bindable` for two-way binding
- **Services** encapsulate system interactions (sound, windows, monitoring)

The timer is implemented as an **async state machine** using `Task` with `Task.sleep` for 0.5-second tick intervals.

See [ARCHITECTURE.md](./ARCHITECTURE.md) for full details.

## Configuration

All settings are persisted to `UserDefaults` as JSON via `SettingsManager`. Key defaults:

| Setting | Default | Range |
|---------|---------|-------|
| Work duration | 20 min | 1–120 min |
| Break duration | 20 sec | 5–300 sec |
| Pre-break warning | 10 sec | 3–30 sec |
| Sound volume | 70% | 0–100% |
| Break start sound | Chime | 5 options |
| Break end sound | Bell | 5 options |
| Theme | Ocean Blue | 6 options |
| Overlay opacity | 40% | 0–100% |
| Blur radius | 10 px | 0–30 px |
| Strict mode | Off | — |
| Launch at login | Off | — |

## Project Vision

Take a Break is intentionally simple. It does one thing well — reminds you to rest your eyes — without collecting data, requiring an account, or phoning home. Every feature decision is filtered through: "Does this help the user take breaks without getting in their way?"

See the [Product Requirements Document](./PRD.md) for the full roadmap.

## Contributing

We welcome contributions! Please read our [Contributing Guide](./CONTRIBUTING.md) before submitting a pull request.

## License

This project is licensed under the [MIT License](./LICENSE).
