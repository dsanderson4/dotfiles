#!/bin/bash
# Hyprland counterpart of i3/bin/i3exit.sh: confirm before ending the session.
select=$(printf 'NO\nYES' | rofi -dmenu -i -no-custom \
    -config ~/.config/rofi/rofidmenu.rasi \
    -p "Exit Hyprland? This will end your Wayland session.")
[ "$select" = "YES" ] || exit 0
if command -v hyprshutdown >/dev/null 2>&1; then
    hyprshutdown
else
    hyprctl dispatch 'hl.dsp.exit()'
fi
