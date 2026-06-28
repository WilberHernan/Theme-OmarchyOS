# Theme OmarchyOS

Monochrome dark theme for Omarchy. Clean, modern, Bibata cursor.

## Dependencies

| Package | Where | Reason |
|---|---|---|
| `bibata-cursor-theme` | AUR | Mouse cursor |
| `Yaru-red-dark` | AUR (yaru-suite) | Icon theme |
| `JetBrainsMono Nerd Font` | AUR (nerd-fonts-jetbrains-mono) | Terminal/UI font |
| `Adwaita-dark` | built-in (gtk-engine) | GTK theme |
| `Ghostty` | extra (or AUR) | Default terminal |

> `setup.sh` auto-installs Bibata cursor; the rest you need manually once.

## Install

```bash
omarchy theme install https://github.com/WilberHernan/Theme-OmarchyOS.git
omarchy theme set theme-omarchyos
~/.config/omarchy/themes/theme-omarchyos/setup.sh
```

**What `setup.sh` does:**
- Installs Bibata cursor if missing
- Copies waybar style (rounded, 55% transparent, monochrome)
- Applies Hyprland animations + rounding 8, opacities, dim inactive
- Disables hyprcursor (Bibata only has XCursor)
- Sets Ghostty as default terminal
- Configures GTK: Adwaita-dark, Yaru-red-dark icons, Bibata cursor 20, rounded inputs, visible caret
- Applies Walker launcher: centered, 13px font, subtext on select, 84% opaque, 12px radius
- Deploys neofetch tengu oni-mask ASCII art
- Adds fish greeting with neofetch
- Applies gsettings for icons, font, cursor

> ⚠️ Log out and back in after install for full effect (cursor, GTK, icons).

## Contents

**Theme (colors, wallpapers):**
- Colors: monochrome grayscale palette
- Terminals: Alacritty, Kitty, Ghostty
- Icons: Yaru-red-dark
- Waybar, Walker, Hyprland, Hyprlock, Mako, SwayOSD colors
- btop, Neovim, VSCode themes

**Dotfiles (`dotfiles/`):**
| File | What it does |
|---|---|
| `waybar/style.css` | 12px radius, 55% background, floating, monochrome |
| `hypr/looknfeel.lua` | 4 curves, 11 animations, rounding 8 |
| `hypr/envs.lua` | XCURSOR theme 20, no_hardware_cursors, NVIDIA env |
| `gtk-3.0/gtk.css` | caret-color, rounded inputs |
| `gtk-3.0/settings.ini` | Adwaita-dark, Yaru-red-dark, Bibata 20 |
| `gtk-4.0/gtk.css` | caret-color |
| `walker/config.toml` | centered, padding 80x300 |
| `walker/themes/custom/style.css` | 13px font, subtext on select, 84% box |
| `neofetch/tengu_mask.txt` | oni-mask braille art |
| `neofetch/config` | clean info display |
| `fish/config.fish` | neofetch on terminal open |
| `icons/default/index.theme` | XCursor fallback to Bibata |
| `kitty.conf`, `alacritty.toml`, `ghostty/config` | terminal colors |

## Credits

- Based on [Aether](https://github.com/omamix/aether) (Omarchy default)
- Wallpaper: wallhaven-7pr99e.png
