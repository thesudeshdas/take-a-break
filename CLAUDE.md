# CLAUDE.md

Instructions for AI agents (Claude Code, Cursor, Copilot, etc.) working on this codebase.

## Build Commands

```bash
xcodegen generate          # Generate .xcodeproj from project.yml (required before building)
open TakeABreak.xcodeproj  # Open in Xcode, then Cmd+R to build and run
./build.sh                 # Release build (generates .app and .xcarchive)
```

There is no test framework configured. Do not attempt to run tests.

## Architecture Rules

This app follows **MVVM with a Service Layer**. Every file belongs to one of these layers:

- **Models** (`TakeABreak/Models/`) -- Pure data types. Enums and structs. No logic, no imports beyond Foundation.
- **ViewModels** (`TakeABreak/ViewModels/`) -- State containers using `@Observable`. Own business logic. Coordinate Services. Never import SwiftUI.
- **Views** (`TakeABreak/Views/`) -- Pure SwiftUI. Bind to ViewModels via `@Bindable`. Never call Services directly. Never contain business logic.
- **Services** (`TakeABreak/Services/`) -- System interaction layer. Wrap AppKit/AVFoundation/CoreGraphics APIs. Stateless where possible.

Do not break this separation. If you need system access from a View, go through a ViewModel that delegates to a Service.

## Hard Constraints

These are non-negotiable. Violating any of these will result in PR rejection:

1. **Zero third-party dependencies.** Do not add Swift Package Manager packages, CocoaPods, or Carthage dependencies. Everything must use Apple platform APIs only.
2. **No network requests.** The app is fully offline. No analytics, no telemetry, no crash reporting, no update checks.
3. **No data collection.** No user data leaves the device. Settings are stored in UserDefaults only.
4. **macOS 14.0+ only.** Do not add backward compatibility shims for older macOS versions.
5. **Ad-hoc code signing only.** `CODE_SIGN_IDENTITY = "-"`. Do not add development team IDs or provisioning profiles.

## Code Patterns

### Use `@Observable`, not `ObservableObject`

```swift
// Correct
@Observable
final class MyViewModel {
    var someState: String = ""
}

// Wrong -- do not use
class MyViewModel: ObservableObject {
    @Published var someState: String = ""
}
```

### Use `Task.sleep` for timing, not `Timer`

```swift
// Correct
timerTask = Task {
    while !Task.isCancelled {
        try? await Task.sleep(for: .seconds(0.5))
        let remaining = target.timeIntervalSince(Date.now)
        // Update state...
    }
}

// Wrong -- do not use
Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in }
```

### Use `NSPanel` for overlay windows, not SwiftUI `Window`

The app uses `NSPanel` for break overlays and pre-break notifications because it needs control over window level, activation behavior, and multi-screen display. Do not replace this with SwiftUI Window scenes.

### Multi-monitor support is required

Any change to the break overlay must work on all connected monitors simultaneously. `WindowService` creates one `NSPanel` per `NSScreen`. Test with multiple displays if you're modifying overlay behavior.

## Project Configuration

- **Do not edit `TakeABreak.xcodeproj` directly.** All project configuration goes in `project.yml`. Run `xcodegen generate` after changes.
- **Bundle ID:** `com.sudeshdas.TakeABreak`
- **Deployment target:** macOS 14.0
- **Swift version:** 5.9

## File Organization

When adding new files:

- New data types go in `TakeABreak/Models/`
- New state management goes in `TakeABreak/ViewModels/`
- New UI goes in `TakeABreak/Views/` under the appropriate subdirectory (`Break/`, `Settings/`, or root for menu bar views)
- New system integrations go in `TakeABreak/Services/`
- New helpers go in `TakeABreak/Utilities/`

## Common Mistakes to Avoid

- Adding SPM dependencies in `project.yml`
- Putting business logic in SwiftUI Views
- Calling system APIs (NSWorkspace, AVCaptureDevice, etc.) from ViewModels instead of through Services
- Forgetting to handle multi-monitor scenarios in overlay changes
- Using `@State` for complex state that should live in a ViewModel
- Editing `.xcodeproj` files directly instead of `project.yml`
