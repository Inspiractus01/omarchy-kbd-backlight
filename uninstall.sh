#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
STATE_DIR="$HOME/.local/state/omarchy/indicators"
HYPRIDLE_CONF="$HOME/.config/hypr/hypridle.conf"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"

echo "==> Stopping services"
systemctl --user disable --now omarchy-kbd-backlight.service omarchy-kbd-backlight-watchdog.timer omarchy-kbd-backlight-resume-watch.service 2>/dev/null || true
pkill -x hypridle 2>/dev/null || true

echo "==> Removing files"
rm -f "$BIN_DIR/omarchy-kbd-backlight" "$BIN_DIR/omarchy-kbd-backlight-idle-hook" "$BIN_DIR/omarchy-kbd-backlight-resume-watch"
rm -f "$STATE_DIR/kbd-backlight-dim-disabled" "$STATE_DIR/kbd-backlight-dim-last"
rm -f "$HYPRIDLE_CONF"
rm -f "$SYSTEMD_USER_DIR/omarchy-kbd-backlight.service" \
      "$SYSTEMD_USER_DIR/omarchy-kbd-backlight-watchdog.service" \
      "$SYSTEMD_USER_DIR/omarchy-kbd-backlight-watchdog.timer" \
      "$SYSTEMD_USER_DIR/omarchy-kbd-backlight-resume-watch.service"
systemctl --user daemon-reload 2>/dev/null || true
rm -f "$HOME/.config/omarchy/hooks/post-update.d/omarchy-kbd-backlight-update.hook"

echo "==> Done."
echo "    Remove the 'trigger.kbd-backlight*' lines from"
echo "    ~/.config/omarchy/extensions/omarchy-menu.jsonc yourself if you added them."
echo "    ~/.config/omarchy/kbd-backlight.conf was left in place."
