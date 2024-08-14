#!/bin/bash
# Rewrite the [gaps] block in ~/.config/aerospace/aerospace.toml: set-gaps.sh on|off|toggle
#
# Bound to shift-alt-g in ~/.config/aerospace/aerospace.toml. Deliberately independent of the
# light/dark appearance toggle (shift-alt-0, ~/.hammerspoon/darkmode.lua).
#
# AeroSpace has no include mechanism and no runtime command to change gaps, so
# the config itself is edited between the marker comments and reloaded. Only
# that block is touched -- the rest of ~/.config/aerospace/aerospace.toml is the source of truth.
#
# "off" drops the outer gaps to zero but keeps a 5px inner gap, so tiled
# windows still have a seam between them. The external monitor's outer.top
# stays reserved for sketchybar in both presets -- outer.left is what current()
# reads to tell the two apart, so keep it 0 in "off" and nonzero in "on".
set -euo pipefail

MODE="${1:-toggle}"
CONF="$HOME/.config/aerospace/aerospace.toml"

# Current state is read back from the config itself, so the toggle survives
# manual edits and reboots without a separate state file.
current() {
  awk '/^# >>> gaps:/,/^# <<< gaps <<</' "$CONF" |
    grep -q '^outer.left.*= 0 }' && echo off || echo on
}

case "$MODE" in
  toggle) [ "$(current)" = on ] && MODE=off || MODE=on ;;
esac

case "$MODE" in
  on)  T=7; LRB=10; INNER=10; EXT_TOP=31; EXT_BOTTOM=0 ;;
  off) T=0; LRB=0; INNER=6; EXT_TOP=31; EXT_BOTTOM=0 ;;
  *) echo "usage: set-gaps.sh on|off|toggle" >&2; exit 1 ;;
esac

BLOCK=$(cat <<EOF
# >>> gaps: managed by ~/.config/aerospace/set-gaps.sh, edited by shift-alt-g >>>
[gaps]
outer.top =        [{ monitor."built-in.*" = $T }, $EXT_TOP]
outer.left =       [{ monitor."built-in.*" = $LRB }, 0]
outer.bottom =     [{ monitor."built-in.*" = $LRB }, $EXT_BOTTOM]
outer.right =      [{ monitor."built-in.*" = $LRB }, 0]
inner.horizontal = [{ monitor."built-in.*" = $INNER }, $INNER]
inner.vertical =   [{ monitor."built-in.*" = $INNER }, $INNER]
# <<< gaps <<<
EOF
)

BLOCK="$BLOCK" python3 - "$CONF" <<'PY'
import os, re, sys
path = sys.argv[1]
s = open(path).read()
new = os.environ["BLOCK"]
pat = re.compile(r"# >>> gaps:.*?# <<< gaps <<<", re.S)
if not pat.search(s):
    sys.exit("gaps markers not found in " + path)
open(path, "w").write(pat.sub(lambda _: new, s, count=1))
PY

/opt/homebrew/bin/aerospace reload-config
