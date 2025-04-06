#!/bin/bash
# Apply a saved wallpaper state: apply.sh light|dark
#
# Live/aerial wallpapers can't be set through NSWorkspace (which is all
# hs.screen:desktopImageURL and the `wallpaper` CLIs can reach) -- macOS drives
# them from this plist via WallpaperAgent. So we swap in a saved snapshot of the
# whole wallpaper store and restart the agent.
#
# To re-capture a state: set the wallpaper by hand, then run
#   cp ~/Library/Application\ Support/com.apple.wallpaper/Store/Index.plist \
#      ~/.config/wallpaper/light.plist
set -euo pipefail

MODE="${1:-}"
SNAP="$HOME/.config/wallpaper/${MODE}.plist"
INDEX="$HOME/Library/Application Support/com.apple.wallpaper/Store/Index.plist"

if [ "$MODE" != "light" ] && [ "$MODE" != "dark" ]; then
    echo "usage: apply.sh light|dark" >&2
    exit 1
fi
[ -f "$SNAP" ] || { echo "missing snapshot: $SNAP" >&2; exit 1; }

cp "$SNAP" "$INDEX"
killall WallpaperAgent 2>/dev/null || true   # relaunches itself and re-reads the plist
