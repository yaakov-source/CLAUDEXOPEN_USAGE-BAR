#!/bin/bash
# Builds AI Usage and installs it to /Applications.
#
#   ./build.sh            build + install + launch
#   ./build.sh --no-install   build into ./build only

set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
APP="$DIR/build/ClaudeUsageBar.app"

if ! command -v clang >/dev/null 2>&1; then
  echo "clang not found. Install the Xcode command line tools first:"
  echo "  xcode-select --install"
  exit 1
fi

echo "Building..."
rm -rf "$DIR/build"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleName</key>
	<string>AIUsageBar</string>
	<key>CFBundleDisplayName</key>
	<string>AI Usage</string>
	<key>CFBundleIdentifier</key>
	<string>com.haicreative.claudeusagebar</string>
	<key>CFBundleExecutable</key>
	<string>AIUsageBar</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>2.0</string>
	<key>CFBundleVersion</key>
	<string>2</string>
	<key>LSMinimumSystemVersion</key>
	<string>12.0</string>
	<key>LSUIElement</key>
	<true/>
	<key>NSHighResolutionCapable</key>
	<true/>
</dict>
</plist>
PLIST

# Objective-C, not Swift: compiling against the SDK's C headers sidesteps the
# swiftinterface/compiler version check that stock Command Line Tools trip on.
clang -O2 -fobjc-arc -Wall \
  -mmacosx-version-min=12.0 \
  -o "$APP/Contents/MacOS/AIUsageBar" \
  "$DIR/main.m" \
  -framework Cocoa

# Cloud-synced folders can attach Finder/File Provider metadata to the fresh
# bundle. Those attributes are not executable content and make codesign refuse
# the bundle, so strip them before applying the ad-hoc signature. The two root
# attributes need explicit removal on File Provider volumes before the recursive
# pass can clear the ordinary provenance attributes.
xattr -d com.apple.FinderInfo "$APP" 2>/dev/null || true
xattr -d 'com.apple.fileprovider.fpfs#P' "$APP" 2>/dev/null || true
xattr -cr "$APP" 2>/dev/null || true
codesign --force --sign - "$APP" >/dev/null 2>&1 || \
  echo "(ad-hoc signing skipped — app will still run)"

echo "Built: $APP"

if [ "${1:-}" = "--no-install" ]; then
  exit 0
fi

echo "Installing to /Applications..."
pkill -f "ClaudeUsageBar|AIUsageBar" 2>/dev/null || true
sleep 1
rm -rf "/Applications/ClaudeUsageBar.app"
cp -R "$APP" "/Applications/ClaudeUsageBar.app"

# Finder can add its own metadata while copying into /Applications, invalidating
# the otherwise valid ad-hoc signature. Clear and sign the installed copy too.
xattr -d com.apple.FinderInfo "/Applications/ClaudeUsageBar.app" 2>/dev/null || true
xattr -d 'com.apple.fileprovider.fpfs#P' "/Applications/ClaudeUsageBar.app" 2>/dev/null || true
xattr -cr "/Applications/ClaudeUsageBar.app" 2>/dev/null || true
codesign --force --sign - "/Applications/ClaudeUsageBar.app" >/dev/null 2>&1 || \
  echo "(installed app signing skipped — app will still run)"

open "/Applications/ClaudeUsageBar.app"

echo
echo "Running AI Usage. Two gauges show ChatGPT and Claude; one number combines them."
echo
echo "ChatGPT usage is read through Codex; Claude usage is read from Claude Code."
echo "macOS may ask once for Keychain access to Claude Code — click 'Always Allow'."
echo
echo "To start it automatically at login:"
echo "  osascript -e 'tell application \"System Events\" to make login item at end with properties {path:\"/Applications/ClaudeUsageBar.app\", hidden:true}'"
echo
echo "To remove it:"
echo "  pkill -f ClaudeUsageBar; rm -rf /Applications/ClaudeUsageBar.app"
