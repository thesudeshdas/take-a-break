# Product Requirements Document — Take a Break

## 1. Overview

**Product Name:** Take a Break
**Version:** 1.0.0
**Platform:** macOS 14.0+ (Sonoma)
**Type:** Native menu bar application
**Bundle ID:** `com.sudeshdas.TakeABreak`

### 1.1 Problem Statement

Prolonged screen time causes eye strain, headaches, and long-term vision problems. The American Academy of Ophthalmology recommends the **20-20-20 rule** — every 20 minutes, look at something 20 feet away for 20 seconds. Most people forget to take these breaks without a reminder.

Existing solutions are often web-based, intrusive, or lack intelligence about when interruptions are inappropriate (during presentations, video calls, or recordings).

### 1.2 Product Vision

A lightweight, native macOS menu bar app that reminds users to take regular eye breaks with smart awareness of their current activity, so breaks happen at the right time — not during important moments.

### 1.3 Success Metrics

| Metric | Target |
|--------|--------|
| Daily active break completions | 12+ per 8-hour workday |
| Break skip rate | < 30% |
| Smart pause accuracy | > 95% correct detection |
| Memory usage | < 30 MB resident |
| CPU usage (idle) | < 0.1% |

---

## 2. User Personas

### 2.1 Primary: Knowledge Worker

- **Profile:** Software developer, designer, writer, or analyst
- **Environment:** macOS, 1-3 monitors, 6-10 hours daily screen time
- **Pain Point:** Forgets to look away from screen; gets eye strain by end of day
- **Need:** Non-intrusive reminders that respect workflow
- **Key Expectation:** App should not interrupt video calls or presentations

### 2.2 Secondary: Student

- **Profile:** University student doing coursework on a Mac
- **Environment:** macOS, single monitor, long study sessions
- **Pain Point:** Extended focus sessions cause fatigue and dry eyes
- **Need:** Simple setup, works out of the box with sensible defaults (20-20-20)

### 2.3 Tertiary: Content Creator

- **Profile:** Streamer, screen recorder, video editor
- **Environment:** macOS, multiple monitors, recording/streaming software running
- **Pain Point:** Break reminders appear on screen during recordings
- **Need:** Smart pause during screen recordings with automatic resume

---

## 3. Features & Requirements

### 3.1 Timer System

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| T-1 | Configurable work interval (1–120 minutes) | P0 | Done |
| T-2 | Configurable break duration (5–300 seconds) | P0 | Done |
| T-3 | Configurable pre-break warning period (3–30 seconds) | P1 | Done |
| T-4 | 20-20-20 rule one-click preset | P0 | Done |
| T-5 | Start / Pause / Resume / Reset controls | P0 | Done |
| T-6 | Skip to break immediately | P1 | Done |
| T-7 | Postpone break by 1 or 5 minutes | P1 | Done |
| T-8 | End break early | P1 | Done |
| T-9 | Completed breaks counter (daily) | P2 | Done |
| T-10 | Auto-start timer on app launch | P2 | Not Started |
| T-11 | Micro-break support (shorter, more frequent) | P3 | Not Started |

### 3.2 Smart Pause

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| SP-1 | Detect screen recording apps (Loom, OBS, CleanShot, ScreenFlow, QuickTime) | P0 | Done |
| SP-2 | Detect active camera usage (video calls) | P0 | Done |
| SP-3 | Detect fullscreen applications | P1 | Done |
| SP-4 | Auto-pause timer when condition detected | P0 | Done |
| SP-5 | Auto-resume when condition ends | P0 | Done |
| SP-6 | Individual toggles per detection type | P1 | Done |
| SP-7 | Display active pause reason in menu bar | P1 | Done |
| SP-8 | 3-second polling interval | P1 | Done |
| SP-9 | Configurable recording app list | P3 | Not Started |
| SP-10 | Detect idle/away (no mouse/keyboard input) | P2 | Not Started |

### 3.3 Break Overlay

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| BO-1 | Full-screen overlay on all connected monitors | P0 | Done |
| BO-2 | Circular countdown progress ring | P0 | Done |
| BO-3 | Customizable break message text | P1 | Done |
| BO-4 | Motivational quotes (toggleable) | P2 | Done |
| BO-5 | Skip/postpone buttons (hidden in strict mode) | P1 | Done |
| BO-6 | Strict mode: remove ability to skip or postpone | P1 | Done |
| BO-7 | Overlay ignores mouse events outside buttons | P1 | Done |
| BO-8 | Exercise suggestions during break | P3 | Not Started |

### 3.4 Pre-Break Notification

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| PB-1 | Floating notification before break starts | P0 | Done |
| PB-2 | Countdown timer in notification | P0 | Done |
| PB-3 | Notification follows mouse cursor | P1 | Done |
| PB-4 | Screen edge detection (keeps notification visible) | P2 | Done |

### 3.5 Menu Bar Interface

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| MB-1 | Menu bar icon with status indication | P0 | Done |
| MB-2 | Timer countdown in menu bar text | P0 | Done |
| MB-3 | Popover with status, controls, and navigation | P0 | Done |
| MB-4 | Quick controls (Start, Pause, Reset, Break Now) | P0 | Done |
| MB-5 | Smart pause reason display | P1 | Done |
| MB-6 | Breaks completed today counter | P2 | Done |
| MB-7 | Settings link | P0 | Done |
| MB-8 | Quit button | P0 | Done |

### 3.6 Sounds

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| S-1 | Separate start/end break sounds | P1 | Done |
| S-2 | Sound options: Chime, Bell, Nature Birds, Water, Silence | P1 | Done |
| S-3 | Volume control (0–100%) | P1 | Done |
| S-4 | Sound preview in settings | P2 | Done |
| S-5 | Global enable/disable toggle | P1 | Done |
| S-6 | Custom sound file support | P3 | Not Started |

### 3.7 Appearance

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| A-1 | Six theme options (Ocean Blue, Forest Green, Warm Sunset, Deep Purple, Dark, Minimal) | P1 | Done |
| A-2 | Theme preview in picker | P2 | Done |
| A-3 | Automatic text color per theme | P1 | Done |
| A-4 | Custom break message | P1 | Done |
| A-5 | Toggle motivational quotes | P2 | Done |
| A-6 | Overlay opacity slider (0–100%) with live preview | P1 | Done |
| A-7 | Blur intensity slider (0–30 px) with live preview | P1 | Done |
| A-8 | Simulated desktop in preview to visualize opacity & blur | P2 | Done |
| A-9 | Custom theme support (user-defined colors) | P3 | Not Started |

### 3.8 Settings & Persistence

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| SET-1 | Tab-based settings window (General, Smart Pause, Sounds, Appearance, About) | P0 | Done |
| SET-2 | All settings persisted to UserDefaults | P0 | Done |
| SET-3 | JSON encoding/decoding for configuration | P0 | Done |
| SET-4 | Reset to defaults | P1 | Done |
| SET-5 | Graceful fallback if stored data is corrupted | P1 | Done |
| SET-6 | Launch at login toggle | P1 | Done |
| SET-7 | Export/import settings | P3 | Not Started |

---

## 4. Technical Requirements

### 4.1 Platform & Tooling

| Requirement | Specification |
|-------------|---------------|
| Language | Swift 5.9 |
| UI Framework | SwiftUI |
| Minimum OS | macOS 14.0 (Sonoma) |
| Build System | XcodeGen + Xcode 15+ |
| Architecture | MVVM with Service Layer |
| Dependencies | None (pure native) |
| Code Signing | Hardened runtime |

### 4.2 System Permissions

| Permission | Purpose | Required |
|------------|---------|----------|
| Camera usage description | Detect if camera is in use for video calls | Yes (Info.plist) |
| Launch at login | ServiceManagement registration | Optional |

### 4.3 Performance Requirements

| Metric | Requirement |
|--------|-------------|
| Memory (idle) | < 30 MB |
| Memory (break overlay) | < 60 MB |
| CPU (idle timer running) | < 0.5% |
| Timer accuracy | +/- 0.5 seconds |
| Smart pause detection latency | < 3 seconds |
| Overlay display latency | < 100 ms |

### 4.4 Reliability

- Timer must continue running accurately across system sleep/wake cycles
- Settings must not be lost on unexpected quit
- App must handle multi-monitor connect/disconnect gracefully
- Smart pause must not cause false positives that permanently block breaks

---

## 5. User Flows

### 5.1 First Launch

```
1. User opens app
2. Eye icon appears in menu bar
3. Timer is idle, shows "Ready" in popover
4. User clicks "Start" → timer begins with 20-20-20 defaults
5. Menu bar shows countdown (MM:SS)
```

### 5.2 Work → Break → Work Cycle

```
1. Timer counts down from 20:00
2. At 0:10 remaining → pre-break notification floats near cursor
3. Notification counts down 10... 9... 8...
4. At 0:00 → full-screen overlay appears on all screens
5. Break sound plays
6. Circular ring counts down 20 seconds
7. Break completes → end sound plays → overlay dismissed
8. Break counter increments → new 20-minute timer starts automatically
```

### 5.3 Smart Pause

```
1. User is working, timer counting down
2. User joins a Zoom call (camera activates)
3. Within 3 seconds: timer pauses, menu bar shows "Auto-paused"
4. User ends call (camera deactivates)
5. Within 3 seconds: timer resumes from where it stopped
```

### 5.4 Postpone Break

```
1. Break overlay appears
2. User clicks "Postpone 5 min"
3. Overlay dismissed, timer set to 5:00
4. After 5 minutes, break triggers again
```

---

## 6. Information Architecture

### 6.1 Settings Tabs

```
Settings Window
├── General
│   ├── 20-20-20 Rule toggle
│   ├── Work duration slider
│   ├── Break duration slider
│   ├── Pre-break warning slider
│   ├── Strict mode toggle
│   └── Launch at login toggle
│
├── Smart Pause
│   ├── Pause during screen recording toggle
│   ├── Pause during video calls toggle
│   └── Pause during fullscreen apps toggle
│
├── Sounds
│   ├── Enable sounds toggle
│   ├── Break start sound picker + preview
│   ├── Break end sound picker + preview
│   └── Volume slider
│
├── Appearance
│   ├── Live preview (simulated desktop + overlay)
│   ├── Theme picker (6 options with preview)
│   ├── Overlay opacity slider (0–100%)
│   ├── Blur intensity slider (0–30 px)
│   ├── Custom break message field
│   └── Show motivational quotes toggle
│
└── About
    ├── App name and version
    └── App description
```

---

## 7. Non-Functional Requirements

### 7.1 Privacy
- No data collection or analytics
- No network requests
- Camera permission is used solely to check if camera is active (no image capture)
- All data stored locally in UserDefaults

### 7.2 Accessibility
- Uses standard SwiftUI controls
- SF Symbols for all icons
- High contrast text on all themes
- Respects system accessibility settings

### 7.3 Compatibility
- macOS 14.0 Sonoma and later
- Apple Silicon and Intel Macs
- Single and multi-monitor configurations

---

## 8. Future Roadmap

### 8.1 Version 1.1 (Near-term)

| Feature | Description |
|---------|-------------|
| Auto-start on launch | Begin timer automatically when app starts |
| Idle detection | Pause timer when user is away from computer |
| Statistics dashboard | Daily/weekly break history and streak tracking |
| Keyboard shortcut | Global hotkey to start/pause timer |

### 8.2 Version 1.2 (Mid-term)

| Feature | Description |
|---------|-------------|
| Custom sound files | Import WAV/MP3 for break sounds |
| Exercise suggestions | Eye exercises and stretch prompts during breaks |
| Focus mode integration | Respect macOS Focus modes |
| Menu bar chart | Visual progress indicator in menu bar |

### 8.3 Version 2.0 (Long-term)

| Feature | Description |
|---------|-------------|
| Custom themes | User-defined colors and backgrounds |
| Widget support | macOS desktop widget showing next break |
| Shortcuts integration | Apple Shortcuts actions for automation |
| Calendar awareness | Skip breaks during calendar events |
| Sync settings | iCloud sync across Macs |
| Configurable recording apps | User-editable list of screen recording apps |
| Export/import settings | Share configurations between machines |

---

## 9. Glossary

| Term | Definition |
|------|------------|
| 20-20-20 Rule | Eye health guideline: every 20 minutes, look at something 20 feet away for 20 seconds |
| Smart Pause | Automatic timer pause when conditions are detected that make interruption inappropriate |
| Strict Mode | Disables the ability to skip or postpone breaks |
| Pre-break Warning | Floating notification shown seconds before a break starts |
| Break Overlay | Full-screen view displayed during a break across all monitors |
| Menu Bar App | macOS application that runs in the system menu bar instead of the Dock |
| LSUIElement | Info.plist key that hides the app from the Dock |
