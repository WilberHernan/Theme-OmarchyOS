# Theme OmarchyOS

Monochrome dark theme for Omarchy. Clean, modern, Bibata cursor, fully bundled.

## Dependencies

Install once before the theme:

```bash
sudo pacman -S ghostty hyprlock
```

> **Nothing else is downloaded.** The icon theme **Colloid-Grey-Dark**, the cursor
> **Bibata-Modern-Classic**, and the fonts **Gunplay** and **Inter** are all
> bundled inside the theme (`setup.sh` copies them from the repo).
> `Adwaita-dark` comes with `gtk-engine`, should already be installed on Omarchy.
> **JetBrainsMono Nerd Font** comes with Omarchy (system default font).
> `hyprlock` comes with Omarchy, but if you don't have it: `sudo pacman -S hyprlock`.
> `ghostty` only if you don't have it (Foot is Omarchy's default).

## Install

```bash
omarchy theme install https://github.com/WilberHernan/Theme-OmarchyOS.git
omarchy theme set theme-omarchyos
~/.config/omarchy/themes/theme-omarchyos/setup.sh
```

**Log out and back in** for everything to take effect.

> `setup.sh` makes **automatic backups** of any config it overwrites
> (`.bak-<timestamp>` next to the file). Re-running it is safe and idempotent.
> It also installs a **hook** in `~/.config/omarchy/hooks/theme-set.d/`: after
> the first run, if you switch themes and come back to `theme-omarchyos`
> (switcher with `T`), the companion configs re-apply automatically.

## Architecture

This theme uses a **two-layer system** to work around Omarchy's security model for git-installed themes.

### Layer 1: Root files — applied by `omarchy theme set`

Files in the repo root are copied by Omarchy to `~/.config/omarchy/current/theme/` during theme activation. From there, apps load them directly or Omarchy uses them to generate configs.

| File | Purpose |
|------|---------|
| `colors.toml` | **Palette source of truth.** Omarchy reads this to color the shell, terminals, editors, browser, and all templated apps. |
| `shell.toml` | Shell surface roles: top bar, menu, notifications, launcher, lock screen, OSD, popups, controls. |
| `waybar.css` | Waybar styles loaded by `~/.config/waybar/style.css` via `@import`. |
| `walker.css` | Walker color definitions loaded by `~/.config/walker/themes/custom/style.css` via `@import`. |
| `swayosd.css` | SwayOSD styles loaded by `~/.config/swayosd/style.css` via `@import`. |
| `hyprlock.conf` | Color variables sourced by `~/.config/hypr/hyprlock.conf`. |
| `mako.ini` | Notification daemon config. |
| `btop.theme` | System monitor colors. |
| `chromium.theme` | Browser theme color. |
| `icons.theme` | Icon set name (`Colloid-Grey-Dark`). |
| `backgrounds/` | Desktop wallpapers. |
| `preview.png` / `preview-unlock.png` | Theme switcher previews. |
| `gtk-3.0/` | GTK3 theme and settings. |
| `gtk-4.0/` | GTK4 theme. |

### Layer 2: `dotfiles/` — copied by `setup.sh`

For security, Omarchy **drops** executable/config files from themes installed via `omarchy theme install`. These files live in `dotfiles/` and are copied to live config paths by `setup.sh`:

| File | Why Omarchy drops it | How the theme works around it |
|------|----------------------|------------------------------|
| `hypr/looknfeel.lua`, `hypr/envs.lua` | `.lua` is executable code (Hyprland runs it at login) | `setup.sh` copies to `~/.config/hypr/` |
| `hypr/hyprlock.conf` | Contains layout + sources root `hyprlock.conf` for colors | `setup.sh` copies to `~/.config/hypr/` |
| `kitty.conf`, `alacritty.toml`, `config` (Ghostty) | Terminal configs name the shell program | `setup.sh` copies to `~/.config/<app>/` |
| `neovim.lua` | `.lua` is executable code (Neovim runs it) | `setup.sh` copies to `~/.config/nvim/lua/plugins/theme.lua` |
| `vscode/extension.json` | References a VS Code extension (arbitrary JS) | Documented for manual install |
| `vscode/terminal-colors.json` | Editor integration | `setup.sh` merges into `settings.json` |
| `fonts/Gunplay_Regular.otf`, `fonts/Inter-VariableFont_*.ttf` | Not part of Omarchy's theme system | `setup.sh` copies to `~/.local/share/fonts/` |
| `icons/Bibata-Modern-Classic/`, `icons/Colloid-Grey-Dark/` | Bundled assets | `setup.sh` copies to `~/.icons/` and `~/.local/share/icons/` |
| `scripts/omarchy-system-lock` | Executable script | `setup.sh` copies to `~/.local/share/omarchy/bin/` |
| `shaders/*.glsl` | Custom GLSL effects for Ghostty | `setup.sh` copies to `~/.config/ghostty/shaders/` |
| `fish/config.fish` | Shell config | `setup.sh` copies to `~/.config/fish/` |
| `uwsm/env` | Session environment variables | `setup.sh` copies to `~/.config/uwsm/` |
| `waybar/style.css` | App wrapper that `@import`s root `waybar.css` | `setup.sh` copies to `~/.config/waybar/` |
| `walker/config.toml`, `walker/themes/custom/style.css` | App config + wrapper that `@import`s root `walker.css` | `setup.sh` copies to `~/.config/walker/` |
| `swayosd/config.toml`, `swayosd/style.css` | App config + wrapper that `@import`s root `swayosd.css` | `setup.sh` copies to `~/.config/swayosd/` |
| `mako/config` | Notification config (identical to root `mako.ini`) | `setup.sh` copies to `~/.config/mako/` |
| `gtk-3.0/*`, `gtk-4.0/*` | GTK theming (identical to root) | `setup.sh` copies to `~/.config/gtk-*/` |

### Why some files exist in both root and `dotfiles/`

GTK, mako, and walker configs exist in both places because:
1. **Root copies** are staged by Omarchy into `current/theme/` — this is the "official" path the theme system uses.
2. **`dotfiles/` copies** are installed by `setup.sh` as a fallback to ensure the configs are in the exact paths some apps expect, and to preserve the `@import` wrapper architecture for waybar, walker, and swayosd.

If Omarchy ever changes how it stages a file, the `dotfiles/` copy ensures the theme still works.

### VS Code extension

This theme is designed to pair with the **Monochromator Dark** extension (`beem.monochromator`). Install it manually:

```bash
code --install-extension beem.monochromator
```

Or search "Monochromator" in the Extensions panel.

## ⚠️ Golden Rules — read this before editing

Omarchy maintains **three copies** of theme files. "Magic" errors (blur lost, black screen, theme reverted) almost always come from updating one copy and forgetting the other two:

| Copy | Path | Who uses it |
|---|---|---|
| 1. Repo (source of truth) | `~/.config/omarchy/themes/theme-omarchyos/` | git, backup, install on another PC |
| 2. Active template | `~/.config/omarchy/current/theme/` | Omarchy copies this whole folder when **re-applying** the theme |
| 3. Live configs | `~/.config/hypr/`, `~/.config/walker/`, `~/.config/waybar/`, etc. | The system runs with these |

**When changing something, sync all three copies:**
```bash
T=~/.config/omarchy/themes/theme-omarchyos
C=~/.config/omarchy/current/theme
cp <changed-file> "$T/..." && cp <changed-file> "$C/..."
```

- Editing **only the repo** → next `omarchy theme set` reverts to the old version
- Editing **only the live copy** → lost on re-apply or reinstall
- `setup.sh` only copies FROM the repo TO live configs: files managed by Omarchy (waybar `config.jsonc`, hyprland loader) are **not touched** and belong to Omarchy, not the theme

## Safe commands

- Restart walker: `omarchy-restart-walker` (DO NOT `nohup walker` directly — breaks CSS `@import` due to wrong HOME)
- Restart waybar: `omarchy-restart-waybar`
- Reload a Hyprland rule on the fly: `hyprctl eval '...'` (`hyprctl reload` does **not** re-evaluate Lua from `looknfeel.lua`)
- Restore from `current/theme` without touching the repo: `omarchy theme set theme-omarchyos` (uses copy 2 as-is)

## Known errors and how they were solved (do not repeat)

| Error | Cause | Fix applied |
|---|---|---|
| Walker looked black without blur | Blur layer rule lived only in live copy and repo; `current/theme` didn't have it → lost on re-apply | `hl.layer_rule` (walker + notifications) in `looknfeel.lua` synced across all 3 copies |
| Waybar as dark band | Had 0.55 opacity but **no blur** → opaque rectangle | Tried blur + glass (commit `49eabb1`), then user decided: **waybar 100% transparent, no blur** (commit `6548fd0`) |
| Hiding walker search input | Neither `display:none` CSS nor native `-n/--nosearch` flag reliably hide it; `--nosearch` broke service flow | **Reverted** (commit `7d5c98d`). Do not try again |
| Old `mako.ini` at root (solid `#121212`) | Omarchy consumed `mako.ini` from root on re-apply → reverted notification glass | Updated to same glass as `dotfiles/mako/config` |
| Cursor 20 vs 16 | `current/theme` was frozen with cursor 20; system uses 16 | Synced `envs.lua` + `uwsm/env` to cursor 16 across all 3 copies |

## Lockscreen

- Clock with **Gunplay** font in Hyadum style (large centered hour)
- **No visible password field** — just type and unlock
- Smooth lock/unlock animation (fade, Apple curve)
- Screen turns off after **15 seconds** of being locked

## Glass structure

| Component | Background | Blur | Border |
|---|---|---|---|
| Walker launcher | `rgba(18,18,18,0.55)` | Yes (layer rule `walker`, `ignore_alpha=0.4`) | `rgba(255,255,255,0.14)` |
| Notifications (mako) | `rgba(30,30,30,0.50)` | Yes | none, radius 12 |
| OSD (swayosd) | `rgba(18,18,18,0.55)` | No (small window) | `rgba(255,255,255,0.10)` |
| Waybar | **transparent (alpha 0)** | **No** | none |

## Full file reference

### Root files (Omarchy-managed)

| File | Role |
|---|---|
| `colors.toml` | Official Omarchy palette with semantic keys |
| `shell.toml` | Shell surface roles and spacing |
| `waybar.css` | Waybar base styles |
| `walker.css` | Walker color definitions |
| `swayosd.css` | SwayOSD styles |
| `hyprlock.conf` | Hyprlock color variables |
| `mako.ini` | Notification config |
| `btop.theme` | btop colors |
| `chromium.theme` | Chromium theme color |
| `icons.theme` | Icon theme name |
| `preview.png` / `preview-unlock.png` | Previews |
| `backgrounds/` | Wallpapers |
| `gtk-3.0/` | GTK3 theme |
| `gtk-4.0/` | GTK4 theme |
| `setup.sh` | Companion installer |

### `dotfiles/` files (setup.sh-managed)

| File | Role |
|---|---|
| `hypr/looknfeel.lua` | 11 animations, rounding 8, blur layer rules |
| `hypr/envs.lua` | Cursor envs, NVIDIA vars |
| `hypr/hyprlock.conf` | Lockscreen layout (sources root `hyprlock.conf`) |
| `kitty.conf` | Kitty terminal colors |
| `alacritty.toml` | Alacritty terminal colors |
| `config` | Ghostty terminal config + cursor shader |
| `neovim.lua` | Monochrome colorscheme for LazyVim |
| `vscode/extension.json` | VS Code extension reference |
| `vscode/terminal-colors.json` | Integrated terminal palette merge |
| `fonts/Gunplay_Regular.otf` | Lockscreen clock font |
| `fonts/Inter-VariableFont_slnt,wght.ttf` | UI font |
| `icons/Bibata-Modern-Classic/` | Cursor theme |
| `icons/Colloid-Grey-Dark/` | Icon theme |
| `scripts/omarchy-system-lock` | Lock script with 15s display-off |
| `shaders/*.glsl` | Cursor smear/blaze effects |
| `uwsm/env` | Persistent session env vars |
| `fish/config.fish` | Fish shell config |
| `waybar/style.css` | Wrapper: `@import` root `waybar.css` |
| `walker/config.toml` | Walker launcher layout |
| `walker/themes/custom/style.css` | Walker styles + `@import` root `walker.css` |
| `swayosd/config.toml` | SwayOSD layout |
| `swayosd/style.css` | Wrapper: `@import` root `swayosd.css` |
| `mako/config` | Notification config (same as root `mako.ini`) |
| `gtk-3.0/gtk.css`, `gtk-3.0/settings.ini` | GTK3 theme (same as root) |
| `gtk-4.0/gtk.css` | GTK4 theme (same as root) |

## License

See `LICENSE`.
