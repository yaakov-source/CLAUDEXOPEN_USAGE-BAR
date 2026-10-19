#!/bin/zsh
set -euo pipefail
release_dir="${0:A:h}"
repo_dir="${release_dir:h:h}"
output_dir="${repo_dir}/build/release-2.1-$(date -u +%Y%m%dT%H%M%SZ)"
app="${output_dir}/AI Usage.app"
mkdir -p "${app}/Contents/MacOS" "${app}/Contents/Resources"
cp "${release_dir}/Info.plist" "${app}/Contents/Info.plist"
clang -O2 -fobjc-arc -Wall -mmacosx-version-min=12.0 -o "${app}/Contents/MacOS/AIUsageBar" "${repo_dir}/main.m" -framework Cocoa
codesign --force --sign - "${app}"
codesign --verify --deep --strict "${app}"
print -r -- "Built ${app}"
