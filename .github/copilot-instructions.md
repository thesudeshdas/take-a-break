Refer to CLAUDE.md in the project root for all architecture rules, build commands, code patterns, and constraints. That file is the single source of truth for AI agents working on this codebase.

Key points:
- Zero third-party dependencies. Do not add SPM packages.
- No network requests. The app is fully offline.
- Use @Observable (Swift 5.9), not ObservableObject.
- MVVM + Service Layer. Views never call Services directly.
- Edit project.yml, not .xcodeproj. Run xcodegen generate after changes.
- Multi-monitor support is required for all overlay changes.
- macOS 14.0+ only. No backward compat shims.
- No test framework is configured. Do not attempt to run tests.
