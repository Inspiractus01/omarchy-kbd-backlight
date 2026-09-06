#!/usr/bin/env bash
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/Inspiractus01/omarchy-kbd-backlight/main"
BIN_DIR="$HOME/.local/bin"
MENU_FILE="$HOME/.config/omarchy/extensions/omarchy-menu.jsonc"
CONF_FILE="$HOME/.config/omarchy/kbd-backlight.conf"

echo "==> Checking dependencies"
command -v brightnessctl >/dev/null || { echo "brightnessctl not found. Install it: omarchy pkg add brightnessctl"; exit 1; }
command -v hypridle >/dev/null || { echo "hypridle not found. This needs Omarchy/Hyprland."; exit 1; }
brightnessctl -d kbd_backlight g >/dev/null 2>&1 || { echo "No 'kbd_backlight' device found. Your keyboard has no controllable backlight."; exit 1; }
command -v dbus-monitor >/dev/null || echo "    Note: dbus-monitor not found -- the instant-restart-on-resume watcher won't work, but the 15min watchdog will still catch a wedge."

echo "==> Installing scripts to $BIN_DIR"
mkdir -p "$BIN_DIR"
curl -fsSL "$REPO_RAW/bin/omarchy-kbd-backlight" -o "$BIN_DIR/omarchy-kbd-backlight"
curl -fsSL "$REPO_RAW/bin/omarchy-kbd-backlight-idle-hook" -o "$BIN_DIR/omarchy-kbd-backlight-idle-hook"
curl -fsSL "$REPO_RAW/bin/omarchy-kbd-backlight-resume-watch" -o "$BIN_DIR/omarchy-kbd-backlight-resume-watch"
chmod 755 "$BIN_DIR/omarchy-kbd-backlight" "$BIN_DIR/omarchy-kbd-backlight-idle-hook" "$BIN_DIR/omarchy-kbd-backlight-resume-watch"

echo "==> Adding menu entries"
mkdir -p "$(dirname "$MENU_FILE")"
if [[ ! -f "$MENU_FILE" ]]; then
  printf '{\n}\n' > "$MENU_FILE"
fi
if grep -q '"trigger.kbd-backlight"' "$MENU_FILE"; then
  echo "    Already added, skipping."
else
  cp "$MENU_FILE" "$MENU_FILE.bak.$(date +%s)"
  SNIPPET_FILE="$(mktemp)"
  curl -fsSL "$REPO_RAW/menu.jsonc" -o "$SNIPPET_FILE"
  python3 - "$MENU_FILE" "$SNIPPET_FILE" <<'PY'
import sys
menu_path, snippet_path = sys.argv[1], sys.argv[2]
snippet = open(snippet_path).read().rstrip("\n")
text = open(menu_path).read()
idx = text.rstrip().rfind("}")
new_text = text[:idx].rstrip()
if new_text and not new_text.endswith(","):
    new_text += ","
new_text += "\n\n" + snippet + "\n}\n"
open(menu_path, "w").write(new_text)
PY
  rm -f "$SNIPPET_FILE"
  echo "    Added (backup: $MENU_FILE.bak.*)"
fi

echo "==> Starting auto-dim"
[[ -f "$CONF_FILE" ]] && source "$CONF_FILE"
"$BIN_DIR/omarchy-kbd-backlight" timeout "${IDLE_SECONDS:-10}" >/dev/null

echo "==> Done. Press SUPER+SPACE and search 'Keyboard Backlight'."
