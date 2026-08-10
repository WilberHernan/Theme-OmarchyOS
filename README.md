# Theme OmarchyOS

Monochrome dark theme for Omarchy. Clean, modern, Bibata cursor.

## Dependencies

Install these once before the theme:

```bash
yay -S yaru-icon-theme nerd-fonts-jetbrains-mono
sudo pacman -S ghostty hyprlock
```

> El cursor **Bibata-Modern-Classic** ya viene incluido en el theme (no necesita instalarse aparte).
> `Adwaita-dark` viene con `gtk-engine`, ya debería estar instalado en Omarchy.
> `hyprlock` viene con Omarchy, pero si no lo tenés: `sudo pacman -S hyprlock`.

## Install

```bash
omarchy theme install https://github.com/WilberHernan/Theme-OmarchyOS.git
omarchy theme set theme-omarchyos
~/.config/omarchy/themes/theme-omarchyos/setup.sh
```

**Cerrar sesión y volver a entrar** para que todo tome efecto.

## What `setup.sh` does

- Copia `looknfeel.lua` (11 animaciones spring/bezier, rounding 8)
- Copia `envs.lua` (variables de cursor)
- Copia `hyprlock.conf` (reloj estilo Hyadum, input invisible, desbloqueo animado)
- Copia `uwsm/env` (variables de cursor persistentes entre sesiones)
- Copia `waybar/style.css` (12px radius, 55% transparente, monocromo)
- Copia configs de terminales (Alacritty, Kitty, Ghostty)
- Copia `gtk-3.0/` y `gtk-4.0/` (tema, iconos, cursor, inputs redondeados)
- Copia `icons/` (cursor Bibata-Modern-Classic)
- Copia `walker/` (centrado, 13px, subtexto al seleccionar)
- Copia `/` (config con specs)
- Copia `fish/config.fish` ( specs al abrir terminal)
- Instala fuente **Gunplay** (para el reloj del lockscreen)
- Copia script de bloqueo propio (15s antes de apagar pantalla)
- Setea Ghostty como terminal default
- Aplica `gsettings` (cursor Bibata 20, fuentes, window theme)

## Lockscreen

- Reloj con fuente **Gunplay** estilo Hyadum (hora grande centrada)
- **Sin campo de contraseña visible** — solo escribís y desbloqueás
- Animación suave al bloquear y desbloquear (fade, curva apple)
- La pantalla se apaga a los **15 segundos** de bloqueada

## Dotfiles

| Archivo | Qué hace |
|---|---|
| `hypr/hyprland.lua` | Loader gestionado por Omarchy (no se incluye en el theme) |
| `hypr/envs.lua` | `XCURSOR_THEME`, `HYPRCURSOR_THEME`, tamaño 20 |
| `hypr/looknfeel.lua` | 4 curvas, 11 animaciones, rounding 8 |
| `hypr/hyprlock.conf` | Lockscreen Hyadum-style: Gunplay clock, fade animation |
| `scripts/omarchy-system-lock` | Lock propio: 15s display-off delay |
| `fonts/Gunplay_Regular.otf` | Fuente Gunplay bundleada para el reloj |
| `uwsm/env` | Cursor envs persistentes via UWSM |
| `waybar/style.css` | Wrapper del usuario que hace `@import` a los colores del theme |
| `gtk-3.0/settings.ini` | Adwaita-dark, Yaru-red-dark, Bibata 20 |
| `icons/Bibata-Modern-Classic/` | Cursor Bibata Modern Classic incluido en el theme |
| `gtk-3.0/gtk.css` | caret-color, inputs redondeados |
| `gtk-4.0/gtk.css` | caret-color |
| `walker/config.toml` | Centrado, padding 80x300 |
| `walker/themes/custom/style.css` | 13px font, subtext en select, 84% box |
| `/config` | Info limpia (sin imagen) |
| `fish/config.fish` |  al abrir terminal |

## Palette

| Token | Hex | Use |
|---|---|---|
| background | `#121212` | window backgrounds |
| foreground | `#bebebe` | primary text |
| accent | `#808080` | accents, selection, borders |
| border | `#525252` | muted borders, comments |
| bright | `#eaeaea` | active/hover, cursor |
| warning | `#a0a0a0` | battery warning, todo (bold) |

This palette is the single source of truth — keep every app config (alacritty, kitty, ghostty, btop, vscode, waybar, mako, walker, swayosd) in sync with it.

## Notes

- `custom_theme.json` is not required: Omarchy never reads it (it is an Omarchist authoring artifact).
- `vscode.json` uses the `{name, extension}` schema Omarchy expects; it points to the "Monochromator Dark" theme from `beem.monochromator` (available on Open VSX, so Omarchy can install it automatically on VS Code and code-oss/VSCodium).
- `neovim.lua` is a lazy.nvim spec (colorscheme `matteblack`) with the monochrome highlights re-applied on every `ColorScheme`; install `tahayvr/matteblack.nvim` in Neovim.
- Third-party assets: Bibata cursor (MIT), wallpaper from wallhaven, Gunplay font — verify the font's redistribution license before any commercial use of this theme.

## Credits

- Based on [Aether](https://github.com/omamix/aether) (Omarchy default)
- Clock style inspired by [Hyadum-Light](https://www.deviantart.com/closebox73/art/Hyadum-Light-conky-1002136777) (Closebox73)
- Wallpaper: wallhaven-7pr99e.png
