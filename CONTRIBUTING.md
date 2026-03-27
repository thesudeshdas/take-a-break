# Contributing to Take a Break

Thank you for your interest in contributing to Take a Break. This document explains how to get started and what to expect during the contribution process.

## Prerequisites

- macOS 14.0 (Sonoma) or later
- Xcode 15+ with Swift 5.9
- XcodeGen (`brew install xcodegen`)

## Getting Started

1. Fork the repository and clone your fork locally.
2. Run `xcodegen generate` in the project root to generate the Xcode project.
3. Open `TakeABreak.xcodeproj` in Xcode.
4. Build and run with Cmd+R.

If the project fails to build, make sure your Xcode Command Line Tools are up to date and that you ran `xcodegen generate` before opening the project.

## How to Contribute

### Before Writing Code

- Open an issue describing what you want to change and why.
- Wait for maintainer approval before starting work on non-trivial changes.
- Bug fixes for existing issues can go straight to a PR.

### Pull Request Process

- One bug fix or one small feature per PR.
- Large PRs will be asked to split into smaller, reviewable pieces.
- Reference the issue your PR addresses (e.g., "Fixes #12").
- Keep commits focused and well-described.

### Code Style

- Follow existing patterns in the codebase.
- MVVM architecture:
  - **Models** have no logic.
  - **ViewModels** manage state.
  - **Views** are pure SwiftUI.
  - **Services** handle system interactions.
- Use Swift 5.9 `@Observable` (not `ObservableObject`).
- No third-party dependencies unless absolutely necessary and approved by maintainers.

### AI-Assisted Code

- AI-assisted code is welcome.
- You must be able to explain every line of your changes during review.
- Don't submit large AI-generated PRs without prior discussion in an issue.

## What We're Looking For

- Bug fixes
- Performance improvements
- New break themes
- Accessibility improvements
- Documentation improvements
- Localization

## What Probably Won't Be Accepted

- Features that add network requests or analytics. The app is fully offline by design.
- Third-party dependencies for things achievable with platform APIs.
- Changes that significantly increase memory or CPU usage.
- Features that make the app intrusive or disruptive to users' workflow.

## Response Times

- Issues are triaged within 48 hours.
- PRs are reviewed within a week.
- This project is maintained in spare time -- patience is appreciated.
