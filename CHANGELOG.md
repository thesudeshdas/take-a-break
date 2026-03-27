# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.0] - 2025-03-27

### Added

- Core break timer system implementing the 20-20-20 rule with configurable work and break durations
- Fullscreen break overlay on all connected monitors with animated countdown ring and fade-in transition
- Transparent blur background on break overlay with adjustable opacity and blur intensity controls
- Theme support for break overlay appearance
- Pre-break floating notification that appears near the cursor before a break starts, with configurable pause duration
- Smart pause detection for screen recording, camera usage, and fullscreen app activity to avoid interrupting focused work
- Menu bar interface with a centered floating panel showing countdown timer and quick controls (skip, postpone, pause/resume)
- Settings panel with sections for general preferences, smart pause rules, sound configuration, and appearance customization
- Live appearance preview in settings for real-time visual feedback
- Text inputs throughout the settings interface for precise value entry
- Sound notifications for break events
- Project documentation including README, product requirements document, and architecture guide covering overlay opacity and blur controls
- Build tooling with XcodeGen project generation and automated build script

### Changed

- Replaced menu bar popover with a centered floating panel for improved usability

### Fixed

- Removed keyboard focus ring from menu bar panel buttons for cleaner visual appearance
