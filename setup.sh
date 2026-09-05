#!/bin/bash
# Theme OmarchyOS — full setup script
# Run this after `omarchy theme install` + `omarchy theme set theme-omarchyos`
#
# SAFETY: every file that overwrites an existing user config first makes a
# timestamped backup in ~/.config/<app>/*.bak-<timestamp>. Re-running this
# script is idempotent and never destroys user-local tweaks silently.

set -e
ONI_DIR="$(cd "${0%/*}" && pwd)"
DOTFILES="$ONI_DIR/dotfiles"
TS="$(date +%Y%m%d-%H%M%S)"

# --- Safe helpers -----------------------------------------------------------
# Copy src -> dst, backing up an existing dst to dst.bak-$TS first.
safe_copy() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && ! cmp -s "$src" "$dst"; then
    cp -a "$dst" "$dst.bak-$TS" 2>/dev/null || true
    echo "  backed up: $(basename "$dst") -> $(basename "$dst").bak-$TS"
  fi
  cp "$src" "$dst"
}

# Recursive copy for directories (cursor theme).
safe_copy_dir() {
  local src="$1" dst_parent="$2"
  mkdir -p "$dst_parent"
  if [ -e "$dst_parent/$(basename "$src")" ] && ! diff -rq "$src" "$dst_parent/$(basename "$src")" >/dev/null 2>&1; then
    cp -a "$dst_parent/$(basename "$src")" "$dst_parent/$(basename "$src").bak-$TS" 2>/dev/null || true
    echo "  backed up: $(basename "$src") -> $(basename "$src").bak-$TS"
  fi
  cp -r "$src" "$dst_parent/"
}

echo "Setting up Theme OmarchyOS companion configs..."
echo "Backups (if any) use suffix .bak-$TS"

# Cursor theme (Bibata-Modern-Classic, ships with the theme)
echo ":: icons"
safe_copy_dir "$DOTFILES/icons/Bibata-Modern-Classic" "$HOME/.icons"

# Waybar (style only — the config.jsonc/modules stay user-owned, NOT themed)
echo ":: waybar (style.css only)"
safe_copy "$DOTFILES/waybar/style.css" "$HOME/.config/waybar/style.css"

# Mako notifications — glass look, top-center, banner pegado al borde superior
echo ":: mako"
safe_copy "$DOTFILES/mako/config" "$HOME/.config/mako/config"

# SwayOSD (volume/brightness OSD) — premium glass to match the theme
echo ":: swayosd"
safe_copy "$DOTFILES/swayosd/config.toml" "$HOME/.config/swayosd/config.toml"
safe_copy "$DOTFILES/swayosd/style.css" "$HOME/.config/swayosd/style.css"

# Terminals (skip if dir missing)
echo ":: terminals"
safe_copy "$DOTFILES/kitty.conf" "$HOME/.config/kitty/kitty.conf"
safe_copy "$DOTFILES/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
safe_copy "$DOTFILES/config" "$HOME/.config/ghostty/config"
safe_copy "$DOTFILES/shaders/cursor_smear_gentleman.glsl" "$HOME/.config/ghostty/shaders/cursor_smear_gentleman.glsl"

# Hyprland (hyprland.lua loader is managed by Omarchy — do not pin it here)
echo ":: hypr (looknfeel/envs/hyprlock — loader stays Omarchy-owned)"
safe_copy "$DOTFILES/hypr/looknfeel.lua" "$HOME/.config/hypr/looknfeel.lua"
safe_copy "$DOTFILES/hypr/envs.lua" "$HOME/.config/hypr/envs.lua"
safe_copy "$DOTFILES/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"

# Fonts (Gunplay for hyprlock clock, Inter for the UI) — additive, no overwrite
echo ":: fonts"
mkdir -p "$HOME/.local/share/fonts"
cp -n "$DOTFILES/fonts/Gunplay_Regular.otf" "$HOME/.local/share/fonts/" 2>/dev/null || true
cp -n "$DOTFILES/fonts/Inter-VariableFont_slnt,wght.ttf" "$HOME/.local/share/fonts/" 2>/dev/null || true
fc-cache -f

# Custom lock script (15s display-off delay)
echo ":: lock script"
safe_copy "$DOTFILES/scripts/omarchy-system-lock" "$HOME/.local/share/omarchy/bin/omarchy-system-lock"

# UWSM env (cursor vars persistent across logins)
echo ":: uwsm/env"
safe_copy "$DOTFILES/uwsm/env" "$HOME/.config/uwsm/env"

# GTK
echo ":: gtk"
safe_copy "$DOTFILES/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
safe_copy "$DOTFILES/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
safe_copy "$DOTFILES/gtk-4.0/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"

# Walker
echo ":: walker"
safe_copy "$DOTFILES/walker/config.toml" "$HOME/.config/walker/config.toml"
safe_copy "$DOTFILES/walker/themes/custom/style.css" "$HOME/.config/walker/themes/custom/style.css"

#  (specs only)
echo ":: "
safe_copy "$DOTFILES//config" "$HOME/.config//config"

# Fish
echo ":: fish"
safe_copy "$DOTFILES/fish/config.fish" "$HOME/.config/fish/config.fish"

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
  # Backup the existing settings before merging, then jq writes to .tmp and moves it in.
  cp -a "$SETTINGS_FILE" "$SETTINGS_FILE.bak-$TS" 2>/dev/null || true
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