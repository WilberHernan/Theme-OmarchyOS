# Theme OmarchyOS

Monochrome dark theme for Omarchy. Clean, modern, Bibata cursor.

## Dependencies

Install these once before the theme:

```bash
yay -S yaru-icon-theme nerd-fonts-jetbrains-mono
sudo pacman -S ghostty
```

> El cursor **Bibata-Modern-Classic** ya viene incluido en el theme (no necesita instalarse aparte).
> `Adwaita-dark` viene con `gtk-engine`, ya debería estar instalado en Omarchy.

## Install

```bash
omarchy theme install https://github.com/WilberHernan/Theme-OmarchyOS.git
omarchy theme set theme-omarchyos
~/.config/omarchy/themes/theme-omarchyos/setup.sh
```

**Cerrar sesión y volver a entrar** para que todo tome efecto.

## What `setup.sh` does

- Copia `hyprland.lua` (carga `envs.lua` con cursor Bibata)
- Copia `looknfeel.lua` (11 animaciones spring/bezier, rounding 8)
- Copia `uwsm/env` (variables de cursor persistentes entre sesiones)
- Copia `waybar/style.css` (12px radius, 55% transparente, monocromo)
- Copia configs de terminales (Alacritty, Kitty, Ghostty)
- Copia `gtk-3.0/` y `gtk-4.0/` (tema, iconos, cursor, inputs redondeados)
- Copia `walker/` (centrado, 13px, subtexto al seleccionar)
- Copia `neofetch/` (arte ASCII tengu oni-mask)
- Copia `fish/config.fish` (neofetch al abrir terminal)
- Setea Ghostty como terminal default
- Aplica `gsettings` (iconos Yaru-red-dark, cursor Bibata 20, fuente JetBrainsMono)

## Dotfiles

| Archivo | Qué hace |
|---|---|
| `hypr/hyprland.lua` | Carga módulos + `require("hypr.envs")` seguro |
| `hypr/envs.lua` | `XCURSOR_THEME`, `HYPRCURSOR_THEME`, tamaño 20 |
| `hypr/looknfeel.lua` | 4 curvas, 11 animaciones, rounding 8 |
| `uwsm/env` | Cursor envs persistentes via UWSM |
| `waybar/style.css` | Flotante, 12px radius, 55% bg |
| `gtk-3.0/settings.ini` | Adwaita-dark, Yaru-red-dark, Bibata 20 |
| `icons/Bibata-Modern-Classic/` | Cursor Bibata Modern Classic incluido en el theme |
| `gtk-3.0/gtk.css` | caret-color, inputs redondeados |
| `gtk-4.0/gtk.css` | caret-color |
| `walker/config.toml` | Centrado, padding 80x300 |
| `walker/themes/custom/style.css` | 13px font, subtext en select, 84% box |
| `neofetch/tengu_mask.txt` | Oni-mask braille art |
| `neofetch/config` | Info limpia |
| `fish/config.fish` | neofetch al abrir terminal |

## Credits

- Based on [Aether](https://github.com/omamix/aether) (Omarchy default)
- Wallpaper: wallhaven-7pr99e.png
