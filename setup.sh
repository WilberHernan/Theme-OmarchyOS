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

# Terminals (skip if dir missing)
cp "$DOTFILES/kitty.conf" ~/.config/kitty/ 2>/dev/null || true
cp "$DOTFILES/alacritty.toml" ~/.config/alacritty/ 2>/dev/null || true
cp "$DOTFILES/config" ~/.config/ghostty/ 2>/dev/null || true

# Hyprland
mkdir -p ~/.config/hypr
cp "$DOTFILES/hypr/hyprland.lua" ~/.config/hypr/
cp "$DOTFILES/hypr/looknfeel.lua" ~/.config/hypr/
cp "$DOTFILES/hypr/envs.lua" ~/.config/hypr/
cp "$DOTFILES/hypr/hyprlock.conf" ~/.config/hypr/

# Gunplay font (for hyprlock clock)
mkdir -p ~/.local/share/fonts
cp "$DOTFILES/fonts/Gunplay_Regular.otf" ~/.local/share/fonts/
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

# Neofetch (specs only)
mkdir -p ~/.config/neofetch
cp "$DOTFILES/neofetch/config" ~/.config/neofetch/

# Fish
mkdir -p ~/.config/fish
cp "$DOTFILES/fish/config.fish" ~/.config/fish/

# Set Ghostty as default terminal
omarchy default terminal ghostty 2>/dev/null || true

# Apply GTK settings (safe: no crash if gsettings unavailable)
if command -v gsettings &>/dev/null; then
  gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" || true
  gsettings set org.gnome.desktop.interface cursor-size 20 || true
  gsettings set org.gnome.desktop.interface icon-theme "Yaru-red-dark" || true
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" || true
  gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font 11" || true
  gsettings set org.gnome.desktop.interface font-name "Adwaita Sans 11" || true
  gsettings set org.gnome.desktop.wm.preferences theme "Adwaita-dark" || true
fi

# Restart waybar
killall -SIGUSR2 waybar 2>/dev/null || (killall waybar 2>/dev/null; sleep 0.5; nohup waybar &>/dev/null &)

echo "Done! Log out and back in for full effect."
