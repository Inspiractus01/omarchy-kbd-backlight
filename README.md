# omarchy-kbd-backlight

Dims your keyboard backlight when you're idle, and restores it when you type or move the mouse. For Omarchy (Hyprland).

## Requirements

- Omarchy
- `brightnessctl`
- a keyboard backlight controllable via `brightnessctl` (device `kbd_backlight`)

## Install

```bash
git clone https://github.com/Inspiractus01/omarchy-kbd-backlight.git
cd omarchy-kbd-backlight
./install.sh
```

## Uninstall

```bash
./uninstall.sh
```

## Use

Open the Omarchy menu (`SUPER+SPACE`), search "Keyboard Backlight". You can:

- turn auto-dim on/off
- set brightness (10/25/50/75/100%)
- set the dim level (0/5/10%)
- set the idle timeout (5/10/20/30/60s)

Or from the terminal:

```bash
omarchy-kbd-backlight brightness 50
omarchy-kbd-backlight dim-percent 0
omarchy-kbd-backlight timeout 10
omarchy-kbd-backlight auto-dim toggle
```

## License

MIT
