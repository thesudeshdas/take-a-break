#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="Take a Break"
SCHEME="TakeABreak"
CONFIGURATION="Release"

cd "$PROJECT_DIR"

echo "==> Generating Xcode project..."
if ! command -v xcodegen &>/dev/null; then
    echo "Error: xcodegen is not installed."
    echo "Install it with: brew install xcodegen"
    exit 1
fi
xcodegen generate

echo "==> Building $APP_NAME ($CONFIGURATION)..."
xcodebuild \
    -project "$SCHEME.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -derivedDataPath "$BUILD_DIR/DerivedData" \
    -archivePath "$BUILD_DIR/$SCHEME.xcarchive" \
    archive \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_ALLOWED=YES \
    | tail -20

ARCHIVE_APP="$BUILD_DIR/$SCHEME.xcarchive/Products/Applications/$SCHEME.app"

if [ ! -d "$ARCHIVE_APP" ]; then
    echo "Error: Build failed — .app bundle not found."
    exit 1
fi

# Copy to build output
OUTPUT_APP="$BUILD_DIR/$APP_NAME.app"
rm -rf "$OUTPUT_APP"
cp -R "$ARCHIVE_APP" "$OUTPUT_APP"

echo ""
echo "==> Build succeeded!"
echo "    App: $OUTPUT_APP"
echo ""
echo "To install to /Applications, run:"
echo "    cp -R \"$OUTPUT_APP\" /Applications/"
echo ""
echo "To launch:"
echo "    open \"$OUTPUT_APP\""
