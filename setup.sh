#!/bin/bash
# Theme OmarchyOS — full setup script
# Run this after `omarchy theme install` + `omarchy theme set theme-omarchyos`

set -e
ONI_DIR="$(cd "${0%/*}" && pwd)"
DOTFILES="$ONI_DIR/dotfiles"

echo "Setting up Theme OmarchyOS companion configs..."

# Cursor theme (Bibata-Modern-Classic, ships with the theme)
mkdir -p ~/.icons
cp -r "$DOTFILES/icons/Bibata-Modern-Classic" ~/.icons/

# Waybar
mkdir -p ~/.config/waybar
cp "$DOTFILES/waybar/style.css" ~/.config/waybar/

# Mako notifications — glass look, top-center, banner pegado al borde superior
mkdir -p ~/.config/mako
cp "$DOTFILES/mako/config" ~/.config/mako/config

# Terminals (skip if dir missing)
cp "$DOTFILES/kitty.conf" ~/.config/kitty/ 2>/dev/null || true
cp "$DOTFILES/alacritty.toml" ~/.config/alacritty/ 2>/dev/null || true
cp "$DOTFILES/config" ~/.config/ghostty/ 2>/dev/null || true

# Hyprland (hyprland.lua loader is managed by Omarchy — do not pin it here)
mkdir -p ~/.config/hypr
cp "$DOTFILES/hypr/looknfeel.lua" ~/.config/hypr/
cp "$DOTFILES/hypr/envs.lua" ~/.config/hypr/
cp "$DOTFILES/hypr/hyprlock.conf" ~/.config/hypr/

# Fonts (Gunplay for hyprlock clock, Inter for the UI)
mkdir -p ~/.local/share/fonts
cp "$DOTFILES/fonts/Gunplay_Regular.otf" ~/.local/share/fonts/
cp "$DOTFILES/fonts/Inter-VariableFont_slnt,wght.ttf" ~/.local/share/fonts/
fc-cache -f

# Custom lock script (15s display-off delay)
cp "$DOTFILES/scripts/omarchy-system-lock" ~/.local/share/omarchy/bin/omarchy-system-lock

# UWSM env (cursor vars persistent across logins)
mkdir -p ~/.config/uwsm
cp "$DOTFILES/uwsm/env" ~/.config/uwsm/

# GTK
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
cp "$DOTFILES/gtk-3.0/gtk.css" ~/.config/gtk-3.0/
cp "$DOTFILES/gtk-3.0/settings.ini" ~/.config/gtk-3.0/
cp "$DOTFILES/gtk-4.0/gtk.css" ~/.config/gtk-4.0/

# Walker
mkdir -p ~/.config/walker/themes/custom
cp "$DOTFILES/walker/config.toml" ~/.config/walker/
cp "$DOTFILES/walker/themes/custom/style.css" ~/.config/walker/themes/custom/

#  (specs only)
mkdir -p ~/.config/
cp "$DOTFILES//config" ~/.config/art/

# Fish
mkdir -p ~/.config/fish
cp "$DOTFILES/fish/config.fish" ~/.config/fish/

# Set Ghostty as default terminal
omarchy default terminal ghostty 2>/dev/null || true

# VS Code / code-oss settings bridge
# Omarchy writes the colorTheme to ~/.config/Code/User/settings.json (VS Code).
# code-oss (Arch/CachyOS) reads from ~/.config/Code - OSS/User/settings.json,
# so symlink them so the theme actually applies on code-oss too.
if command -v code &>/dev/null && [ "$(basename "$(readlink -f "$(command -v code)")")" = "code-oss" ]; then
  OSS_SETTINGS_DIR="$HOME/.config/Code - OSS/User"
  mkdir -p "$OSS_SETTINGS_DIR"
  if [ ! -e "$OSS_SETTINGS_DIR/settings.json" ]; then
    ln -s "$HOME/.config/Code/User/settings.json" "$OSS_SETTINGS_DIR/settings.json"
    echo "Linked code-oss settings to VS Code settings (colorTheme applies automatically)"
  fi
fi

# Merge monochrome terminal colors into VS Code / code-oss settings
# (keeps the integrated terminal palette in sync with the system terminals)
if command -v jq &>/dev/null && [ -f "$DOTFILES/vscode/terminal-colors.json" ]; then
  SETTINGS_FILE="$HOME/.config/Code/User/settings.json"
  mkdir -p "$(dirname "$SETTINGS_FILE")"
  [ -f "$SETTINGS_FILE" ] || printf '{}\n' >"$SETTINGS_FILE"
  jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$DOTFILES/vscode/terminal-colors.json" >"$SETTINGS_FILE.tmp" \
    && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
  echo "Merged monochrome terminal colors into editor settings"
fi

# Apply GTK settings (safe: no crash if gsettings unavailable)
if command -v gsettings &>/dev/null; then
  # Apply the rest via gsettings (no Omarchy equivalent: cursor, fonts, window theme)
  gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" || true
  gsettings set org.gnome.desktop.interface cursor-size 16 || true
  gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font 10" || true
  gsettings set org.gnome.desktop.interface font-name "Inter 10.5" || true
  gsettings set org.gnome.desktop.wm.preferences theme "Adwaita-dark" || true
fi

# Restart waybar
killall -SIGUSR2 waybar 2>/dev/null || (killall waybar 2>/dev/null; sleep 0.5; nohup waybar &>/dev/null &)

echo "Done! Log out and back in for full effect."
