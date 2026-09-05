#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
STATE_DIR="$HOME/.local/state/omarchy/indicators"
HYPRIDLE_CONF="$HOME/.config/hypr/hypridle.conf"

echo "==> Stopping hypridle"
pkill -x hypridle 2>/dev/null || true

echo "==> Removing files"
rm -f "$BIN_DIR/omarchy-kbd-backlight" "$BIN_DIR/omarchy-kbd-backlight-idle-hook"
rm -f "$STATE_DIR/kbd-backlight-dim-disabled" "$STATE_DIR/kbd-backlight-dim-last"
rm -f "$HYPRIDLE_CONF"

echo "==> Done."
echo "    Remove the 'trigger.kbd-backlight*' lines from"
echo "    ~/.config/omarchy/extensions/omarchy-menu.jsonc yourself if you added them."
echo "    ~/.config/omarchy/kbd-backlight.conf was left in place."
