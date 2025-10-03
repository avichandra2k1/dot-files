#!/bin/bash
# Point btop.conf's color_theme at a light or dark theme based on the current
# macOS appearance. btop only reads its config at startup, so this must run
# before btop launches (see the btop() wrapper in ~/.zshrc).
#
# Swap these for any theme in /opt/homebrew/share/btop/themes or
# ~/.config/btop/themes (use the filename without ".theme").
LIGHT_THEME="kanagawa-lotus"
DARK_THEME="Default"

CONF="$HOME/.config/btop/btop.conf"
[ -f "$CONF" ] || exit 0

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
    THEME="$DARK_THEME"
else
    THEME="$LIGHT_THEME"
fi

# Only rewrite when it actually differs, so btop.conf isn't churned every launch.
if ! grep -q "^color_theme = \"$THEME\"$" "$CONF"; then
    sed -i '' "s|^color_theme = .*|color_theme = \"$THEME\"|" "$CONF"
fi
