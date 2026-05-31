#!/bin/bash
# Oni Theme — full setup script
# Run this after `omarchy theme set oni` to apply companion configs.

set -e
ONI_DIR="${0%/*}"
DOTFILES="$ONI_DIR/dotfiles"

echo "Setting up Theme OmarchyOS companion configs..."

# Waybar
mkdir -p ~/.config/waybar
cp "$DOTFILES/waybar/style.css" ~/.config/waybar/

# Terminals
cp "$DOTFILES/kitty.conf" ~/.config/kitty/ 2>/dev/null || true
cp "$DOTFILES/alacritty.toml" ~/.config/alacritty/ 2>/dev/null || true
cp "$DOTFILES/config" ~/.config/ghostty/ 2>/dev/null || true

# Hyprland
mkdir -p ~/.config/hypr
cp "$DOTFILES/hypr/looknfeel.lua" ~/.config/hypr/
cp "$DOTFILES/hypr/envs.lua" ~/.config/hypr/

# GTK
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
cp "$DOTFILES/gtk-3.0/gtk.css" ~/.config/gtk-3.0/
cp "$DOTFILES/gtk-3.0/settings.ini" ~/.config/gtk-3.0/
cp "$DOTFILES/gtk-4.0/gtk.css" ~/.config/gtk-4.0/

# Walker
mkdir -p ~/.config/walker/themes/custom
cp "$DOTFILES/walker/config.toml" ~/.config/walker/
cp "$DOTFILES/walker/themes/custom/style.css" ~/.config/walker/themes/custom/

# Neofetch
mkdir -p ~/.config/neofetch
cp "$DOTFILES/neofetch/tengu_mask.txt" ~/.config/neofetch/
cp "$DOTFILES/neofetch/config" ~/.config/neofetch/

# Fish
mkdir -p ~/.config/fish
cp "$DOTFILES/fish/config.fish" ~/.config/fish/

# Apply GTK settings
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-red-dark"
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic"
gsettings set org.gnome.desktop.interface cursor-size 20
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font 11"
gsettings set org.gnome.desktop.interface font-name "Adwaita Sans 11"
gsettings set org.gnome.desktop.wm.preferences theme "Adwaita-dark"

# Restart services
killall -SIGUSR2 waybar 2>/dev/null || (killall waybar 2>/dev/null; sleep 0.5; waybar &)

echo "Done! Log out and back in for full effect."
