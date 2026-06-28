# Theme OmarchyOS

Monochrome dark theme for Omarchy. Clean, modern — matching Bibata Modern Classic.

## Quick Install (colors + wallpaper only)

```bash
omarchy theme install https://github.com/WilberHernan/Theme-OmarchyOS.git
```

## Full Setup (includes all companion configs)

After installing the theme:

```bash
~/.config/omarchy/themes/theme-omarchyos/setup.sh
```

This copies: waybar style (rounded, transparent), Hyprland animations + rounding, Bibata cursor + GTK styling, custom walker theme, neofetch tengu mask, fish greeting.

> Run `omarchy theme set theme-omarchyos` and then `~/.config/omarchy/themes/theme-omarchyos/setup.sh` on any fresh Omarchy install to get the exact same look.

## What's included

**Theme (colors, wallpapers):**
- Colors: monochrome grayscale palette
- Terminals: Alacritty, Kitty, Ghostty
- Icons: Yaru-red-dark
- Waybar, Walker, Hyprland, Hyprlock, Mako, SwayOSD colors
- btop, Neovim, VSCode themes

**Dotfiles (companion configs in `dotfiles/`):**
- waybar/style.css — rounded, transparent waybar (12px border radius, 55% background)
- hypr/looknfeel.lua — 11 animations (spring/bezier curves), rounding 8
- hypr/envs.lua — Bibata cursor, hyprcursor disabled
- gtk-3.0/ — cursor theme, icons, GTK styling (rounded inputs, visible caret)
- gtk-4.0/gtk.css — matching GTK4 caret styling
- walker/ — centered launcher, font 13px, subtext on select
- neofetch/ — tengu oni-mask ASCII art, clean info display
- fish/config.fish — neofetch on terminal open

## Cursor

Requires [Bibata-Modern-Classic](https://github.com/ful1e5/Bibata_Cursor) installed:

```bash
yay -S bibata-cursor-theme
```

## Credits

- Based on [Aether](https://github.com/omamix/aether) (Omarchy default)
- Wallpaper: wallhaven-7pr99e.png
