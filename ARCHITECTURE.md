# Architecture — Take a Break

## 1. High-Level Architecture

```mermaid
graph TD
    App["TakeABreakApp<br/><i>@main App entry point</i>"]
    App --> MBE["MenuBarExtra<br/>(floating panel)"]
    App --> SS["Settings Scene<br/>(window)"]

    MBE --> Views
    SS --> Views

    subgraph Views ["Views (SwiftUI)"]
        direction LR
        V1["MainPanelView<br/>TimerControlView"]
        V2["BreakOverlayView<br/>BreakCountdown<br/>BreakMessage<br/>PreBreakNotif"]
        V3["SettingsView<br/>GeneralSettings<br/>SmartPauseSettings<br/>SoundsSettings<br/>AppearanceSettings<br/>AboutSettings"]
    end

    Views -->|"@Bindable"| ViewModels

    subgraph ViewModels ["ViewModels (@Observable)"]
        direction LR
        TVM["TimerViewModel<br/>- phase<br/>- smartPause<br/>- breaksToday"]
        SM["SettingsManager<br/>(singleton)<br/>- configuration<br/>- UserDefaults"]
        SM -->|reads| TVM
    end

    ViewModels -->|"delegates to"| Services

    subgraph Services
        direction LR
        SPS["SmartPauseService<br/>- monitorReasons()"]
        SND["SoundService<br/>- playSound()"]
        WS["WindowService<br/>- showOverlay()<br/>- showPreBreak()"]
        LAL["LaunchAtLoginService<br/>- enable/disable"]
        NS["NotificationService<br/>- sendNotification"]
    end

    Services -->|"uses"| Models

    subgraph Models ["Models (Data)"]
        direction LR
        M1["TimerPhase<br/>PausedFrom<br/>SmartPauseReason"]
        M2["BreakConfiguration<br/>BreakSoundType<br/>BreakBackgroundType"]
    end
```

## 2. Design Patterns

### 2.1 MVVM (Model-View-ViewModel)

The app follows strict MVVM separation:

- **Models** (`Models/`) — Pure data types with no business logic. Enums and structs that define the shape of data.
- **ViewModels** (`ViewModels/`) — State containers using `@Observable`. Own business logic and coordinate services.
- **Views** (`Views/`) — SwiftUI views that bind to ViewModels via `@Bindable`. No direct service access.

### 2.2 Service Layer

Services encapsulate all system-level interactions, keeping ViewModels testable and focused on state:

| Service | Responsibility | System APIs Used |
|---------|---------------|------------------|
| `SmartPauseService` | Monitor recording, camera, fullscreen | `NSWorkspace`, `AVCaptureDevice`, `CGWindowListCopyWindowInfo` |
| `SoundService` | Play system sounds | `NSSound` |
| `WindowService` | Create/manage overlay panels | `NSPanel`, `NSScreen`, `NSEvent` |
| `LaunchAtLoginService` | Register for login launch | `SMAppService` |
| `NotificationService` | System notifications | `UNUserNotificationCenter` |

### 2.3 State Machine

The timer is modeled as a finite state machine via the `TimerPhase` enum:

```mermaid
stateDiagram-v2
    [*] --> IDLE
    IDLE --> WORKING : start()
    WORKING --> PRE_BREAK : timer reaches warning period
    WORKING --> PAUSED : manual or smart pause
    PAUSED --> WORKING : resume
    PRE_BREAK --> ON_BREAK : countdown reaches 0
    ON_BREAK --> WORKING : break ends (auto or manual)

    state WORKING {
        [*] : remaining: T
    }
    state PAUSED {
        [*] : from, remaining: T
    }
    state PRE_BREAK {
        [*] : remaining: T
    }
    state ON_BREAK {
        [*] : remaining: T
    }
```

**Phase transitions:**
- `idle → working` — User clicks Start
- `working → preBreak` — Remaining time reaches warning threshold
- `preBreak → onBreak` — Warning countdown reaches 0
- `onBreak → working` — Break completes (auto) or user ends early
- `working ↔ paused` — Manual pause or smart pause trigger/release

### 2.4 Async Task-Based Timing

Instead of `Timer.scheduledTimer`, the app uses Swift Concurrency:

```swift
timerTask = Task {
    while !Task.isCancelled {
        try? await Task.sleep(for: .seconds(0.5))  // 2 ticks/second
        let remaining = target.timeIntervalSince(Date.now)
        // Update phase...
    }
}
```

Benefits:
- Clean cancellation via `Task.cancel()`
- No retain cycle concerns (uses `[weak self]`)
- Date-based accuracy (not accumulated intervals)
- Runs on `@MainActor` for thread safety

## 3. Data Flow

### 3.1 Settings Flow

```mermaid
graph TD
    A["SettingsView (UI)"] -->|"@Bindable"| B["SettingsManager.shared.configuration"]
    B -->|"didSet"| C["UserDefaults (JSON encoded)"]
    C -->|"on launch"| D["SettingsManager.init() loads BreakConfiguration"]
    D -->|"accessed by"| E["TimerViewModel.settings.configuration"]
```

`SettingsManager` is a singleton using `@Observable`. When any property of `BreakConfiguration` changes, it is automatically JSON-encoded and written to `UserDefaults`. On launch, it decodes the stored JSON or falls back to defaults.

### 3.2 Timer → UI Flow

```mermaid
graph TD
    A["TimerViewModel.phase (state changes)"] -->|"@Observable"| B["SwiftUI detects change"]
    B --> C["MenuBarView re-renders<br/>(countdown, status text)"]
    B --> D["BreakOverlayView re-renders<br/>(progress ring, time)"]
    B --> E["PreBreakNotificationView re-renders<br/>(countdown)"]
```

### 3.3 Smart Pause Flow

```mermaid
graph TD
    A["SmartPauseService.monitorPauseReasons()"] -->|"AsyncStream (yields every 3s)"| B["TimerViewModel.startSmartPauseMonitoring()"]
    B --> C["filters by user settings<br/>updates smartPauseReasons"]
    C --> D["reasons not empty + working → pause timer"]
    C --> E["reasons empty + was auto-paused → resume timer"]
```

## 4. Window Management

### 4.1 Break Overlay (Multi-Screen)

`WindowService` creates one `NSPanel` per connected `NSScreen`:

```swift
for screen in NSScreen.screens {
    let panel = NSPanel(...)
    panel.setFrame(screen.frame, display: true)
    panel.level = .screenSaver  // Above most windows
    panel.styleMask = [.borderless, .nonactivatingPanel]
    // Host SwiftUI BreakOverlayView
}
```

Properties:
- `level: .screenSaver` — Displays above normal windows
- `styleMask: .nonactivatingPanel` — Doesn't steal focus
- `collectionBehavior: .canJoinAllSpaces` — Visible on all Spaces
- `NSVisualEffectView.material` — Dynamic based on user's blur radius setting (`.sheet` for 0–5, `.hudWindow` for 5–15, `.fullScreenUI` for 15+)
- Overlay opacity driven by `overlayOpacity` config value

### 4.2 Pre-Break Notification

A floating `NSPanel` that tracks the mouse cursor:

```mermaid
graph TD
    A["Mouse position detected via<br/>NSEvent.addGlobalMonitorForEvents"] --> B["Panel repositioned near cursor"]
    B -->|"with edge detection"| C["If near screen edge → flip to opposite side"]
```

Properties:
- `ignoresMouseEvents: true` — Click-through
- `level: .floating` — Above normal windows but below overlay
- Positioned with offset from cursor, respecting screen bounds

## 5. File Dependency Graph

```
TakeABreakApp.swift
├── TimerViewModel
│   ├── SettingsManager → BreakConfiguration
│   │                     ├── BreakSoundType
│   │                     └── BreakBackgroundType
│   ├── SmartPauseService → SmartPauseReason
│   ├── SoundService → BreakSoundType
│   ├── WindowService
│   │   ├── BreakOverlayView
│   │   │   ├── BreakCountdownView
│   │   │   └── BreakMessageView
│   │   └── PreBreakNotificationView
│   └── AppState (TimerPhase, PausedFrom)
│
├── MainPanelView
│   └── TimerControlView
│
└── SettingsView
    ├── GeneralSettingsView
    ├── SmartPauseSettingsView
    ├── SoundsSettingsView
    ├── AppearanceSettingsView
    └── AboutSettingsView
```

## 6. Key Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| State management | `@Observable` (Swift 5.9) | Modern, less boilerplate than `ObservableObject` |
| Timer implementation | `Task.sleep` with `Date` targets | More accurate than accumulated intervals; clean cancellation |
| Overlay windows | `NSPanel` (not SwiftUI Window) | Full control over window level, activation behavior, and multi-screen |
| Smart pause polling | `AsyncStream` with 3s interval | Lightweight; avoids notification-based complexity |
| Settings persistence | `UserDefaults` + `Codable` JSON | Simple, reliable; no need for Core Data or files |
| Sound playback | `NSSound` (system sounds) | Zero-dependency; instant playback; no bundled audio files |
| Menu bar | `MenuBarExtra` with `.window` style | Native SwiftUI API; proper popover behavior |
| Project generation | XcodeGen (`project.yml`) | Avoids Xcode project merge conflicts; declarative configuration |
| Dependencies | None | Reduces maintenance burden; all requirements met by platform APIs |

## 7. Threading Model

```
@MainActor
├── TimerViewModel (all state mutations)
├── WindowService (NSPanel operations)
├── All SwiftUI Views
│
Background (via Task)
├── Timer tick loops (sleep + main actor callback)
├── SmartPauseService.monitorPauseReasons()
│   └── Yields to MainActor via AsyncStream consumption
```

All state is confined to `@MainActor`. Background work is limited to:
- `Task.sleep` intervals in timer loops
- System API calls in `SmartPauseService` (polling)

Both feed results back to the main actor through Swift Concurrency's actor isolation.
