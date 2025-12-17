#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$ROOT_DIR/Preferences"

mkdir -p "$OUT_DIR"

domains=(
  com.apple.AppleMultitouchTrackpad
  com.apple.controlcenter
  com.apple.dock
  com.apple.finder
  com.apple.Safari.SandboxBroker
  com.apple.screencapture
  com.apple.Spotlight
)

echo "Exporting -globalDomain -> Preferences/.GlobalPreferences.plist"
defaults export -globalDomain "$OUT_DIR/.GlobalPreferences.plist"
plutil -convert xml1 "$OUT_DIR/.GlobalPreferences.plist"

for domain in "${domains[@]}"; do
  echo "Exporting $domain -> Preferences/$domain.plist"
  defaults export "$domain" "$OUT_DIR/$domain.plist"
  plutil -convert xml1 "$OUT_DIR/$domain.plist"
done

echo "Done: $OUT_DIR"

