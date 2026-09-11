# Theme OmarchyOS

Monochrome dark theme for Omarchy. Clean, modern, Bibata cursor.

## Dependencies

Install these once before the theme:

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

## What the theme provides

### Applied automatically by Omarchy

These files live in the theme root and are consumed by `omarchy theme set`:

| File | What it styles |
|------|---------------|
| `colors.toml` | Palette for the shell, terminals, editors, browser, and all apps |
| `shell.toml` | Omarchy shell surfaces: top bar, menu, notifications, launcher, lock |
| `waybar.css` | Top bar appearance (transparent, Inter 11px, monochrome) |
| `walker.css` | Application launcher (glass card, 13px, monochrome) |
| `swayosd.css` | Volume/brightness OSD (glass, rounded) |
| `mako.ini` | Notification daemon config |
| `btop.theme` | System monitor colors |
| `chromium.theme` | Browser theme color |
| `icons.theme` | Icon set name (`Colloid-Grey-Dark`) |
| `backgrounds/` | Desktop wallpapers |
| `preview.png` / `preview-unlock.png` | Theme selector previews |

### Applied by `setup.sh` (files Omarchy drops from git-installed themes)

For security, Omarchy drops executable/config files from themes installed via `omarchy theme install`:

| File | Why it's dropped | How we work around it |
|------|------------------|----------------------|
| `hypr/*.lua` | `.lua` is executable code | `setup.sh` copies from `dotfiles/hypr/` |
| Terminal configs (`kitty.conf`, `alacritty.toml`, `ghostty.conf`) | They name the shell program | `setup.sh` copies from `dotfiles/` |
| `neovim.lua` | `.lua` is executable code | `setup.sh` copies to `~/.config/nvim/lua/plugins/theme.lua` |
| Fonts (`Gunplay`, `Inter`) | Not part of theme system | `setup.sh` copies to `~/.local/share/fonts/` |
| Icon bundles (`Bibata`, `Colloid`) | Not part of theme system | `setup.sh` copies to `~/.icons/` and `~/.local/share/icons/` |
| `scripts/omarchy-system-lock` | Executable script | `setup.sh` copies to `~/.local/share/omarchy/bin/` |
| Ghostty cursor shaders | Custom GLSL effects | `setup.sh` copies to `~/.config/ghostty/shaders/` |
| `fish/config.fish` | Shell config | `setup.sh` copies to `~/.config/fish/` |
| `uwsm/env` | Session environment | `setup.sh` copies to `~/.config/uwsm/` |
| VS Code terminal colors | Editor integration | `setup.sh` merges into settings.json |

### VS Code extension

The theme references the **Monochromator Dark** extension (`beem.monochromator`).
Install it manually in VS Code:

```bash
code --install-extension beem.monochromator
```

Or search "Monochromator" in the Extensions panel.

## ⚠️ GOLDEN RULES — read this before editing the theme

Omarchy maintains **THREE copies** of theme files. "Magic" errors (blur lost,
black screen, theme reverted) almost always come from updating ONE copy and
forgetting the other two:

| Copy | Path | Who uses it |
|---|---|---|
| 1. Repo (source of truth) | `~/.config/omarchy/themes/theme-omarchyos/` | git, backup, install on another PC |
| 2. Active template | `~/.config/omarchy/current/theme/` | Omarchy copies this whole folder when **re-applying** the theme |
| 3. Live configs | `~/.config/hypr/`, `~/.config/walker/`, `~/.config/waybar/`, etc. | The system runs with these |

**When changing something, sync all 3 copies:**
```bash
T=~/.config/omarchy/themes/theme-omarchyos
C=~/.config/omarchy/current/theme
cp <changed-file> "$T/..." && cp <changed-file> "$C/..."
```

- Editing **only the repo** → next `omarchy theme set` reverts to the old version
- Editing **only the live copy** → lost on re-apply or reinstall
- `setup.sh` only copies FROM the repo TO live configs: files managed by Omarchy (waybar `config.jsonc`, hyprland loader) are **not touched** and belong to Omarchy, not the theme

## Known errors and how they were solved (don't repeat)

| Error | Cause | Fix applied |
|---|---|---|
| Walker looked black without blur | Blur layer rule lived only in live copy and repo; `current/theme` didn't have it → lost on re-apply | `hl.layer_rule` (walker + notifications) in `looknfeel.lua` synced across all 3 copies |
| Waybar as dark band | Had 0.55 opacity but **no blur** → opaque rectangle | Tried blur + glass (commit `49eabb1`), then user decided: **waybar 100% transparent, no blur** (commit `6548fd0`) |
| Hiding walker search input | Neither `display:none` CSS nor native `-n/--nosearch` flag reliably hide it; `--nosearch` broke service flow | **Reverted** (commit `7d5c98d`). Don't try again |
| Old `mako.ini` at root (solid `#121212`) | Omarchy consumed `mako.ini` from root on re-apply → reverted notification glass | Updated to same glass as `dotfiles/mako/config` |
| Cursor 20 vs 16 | `current/theme` was frozen with cursor 20; system uses 16 | Synced `envs.lua` + `uwsm/env` to cursor 16 across all 3 copies |

### Safe commands

- Restart walker: `omarchy-restart-walker` (DO NOT `nohup walker` directly — breaks CSS `@import` due to wrong HOME)
- Restart waybar: `omarchy-restart-waybar`
- Reload a Hyprland rule on the fly: `hyprctl eval '...'` (`hyprctl reload` does **not** re-evaluate Lua from `looknfeel.lua`)
- Restore from `current/theme` without touching the repo: `omarchy theme set theme-omarchyos` (uses copy 2 as-is)

## What `setup.sh` does

- Copies `looknfeel.lua` (11 spring/bezier animations, rounding 8, blur layer rules)
- Copies `envs.lua` (cursor variables, size 16)
- Copies `hyprlock.conf` (Hyadum-style clock, invisible input, animated unlock)
- Copies `uwsm/env` (cursor envs persistent across sessions)
- Copies `waybar/style.css` (Inter 11, no bold, **transparent, no blur**)
- **Does not** touch `waybar/config.jsonc` (modules) — belongs to Omarchy; modules and weather are removed/edited manually
- Copies `mako/config` (glass, top-center, banner stuck to top)
- Copies `swayosd/` (premium glass OSD)
- Copies terminal configs (Alacritty, Kitty, Ghostty) + cursor shaders (Gentle-AI smear)
- Copies `gtk-3.0/` and `gtk-4.0/` (theme, icons, cursor, rounded inputs)
- Copies `icons/` (cursor Bibata-Modern-Classic + icon theme Colloid-Grey-Dark to `~/.local/share/icons` — 100% offline, no downloads)
- Installs theme-set hook for auto-re-application on theme switch
- Copies `walker/` (centered, 13px, subtext on select)
- Copies `fish/config.fish` (clean terminal on open)
- Installs fonts **Gunplay** (lockscreen clock) and **Inter** (UI)
- Copies custom lock script (15s display-off delay)
- Sets Ghostty as default terminal
- Symlinks code-oss → VS Code settings (so colorTheme applies in code-oss too)
- Merges monochrome colors into editor integrated terminal (`dotfiles/vscode/terminal-colors.json`)
- Applies `gsettings` (cursor Bibata 16, icon theme Colloid-Grey-Dark, fonts Inter 10.5 / JetBrainsMono 10, window theme)

## Lockscreen

- Clock with **Gunplay** font in Hyadum style (large centered hour)
- **No visible password field** — just type and unlock
- Smooth lock/unlock animation (fade, Apple curve)
- Screen turns off after **15 seconds** of being locked

## Glass structure (current look)

| Component | Background | Blur | Border |
|---|---|---|---|
| Walker launcher | `rgba(18,18,18,0.55)` | Yes (layer rule `walker`, `ignore_alpha=0.4`) | `rgba(255,255,255,0.14)` |
| Notifications (mako) | `rgba(30,30,30,0.50)` | Yes | none, radius 12 |
| OSD (swayosd) | `rgba(18,18,18,0.55)` | No (small window) | `rgba(255,255,255,0.10)` |
| Waybar | **transparent (alpha 0)** | **No** | none |

## Dotfiles

| File | What it does |
|---|---|
| `hypr/hyprland.lua` | Loader managed by Omarchy (not included in theme) |
| `hypr/envs.lua` | `XCURSOR_THEME`, `HYPRCURSOR_THEME`, size 16 |
| `hypr/looknfeel.lua` | 4 curves, 11 animations, rounding 8, blur layer rules |
| `hypr/hyprlock.conf` | Hyadum-style lockscreen: Gunplay clock, fade animation |
| `scripts/omarchy-system-lock` | Custom lock: 15s display-off delay |
| `fonts/Gunplay_Regular.otf` | Bundled Gunplay font for lockscreen clock |
| `fonts/Inter-VariableFont_slnt,wght.ttf` | Bundled Inter UI font |
| `uwsm/env` | Cursor envs persistent via UWSM |
| `waybar/style.css` | Wrapper that `@import`s theme colors |
| `mako/config` | Glass notifications, top-center, banner stuck to top |
| `swayosd/style.css` | Premium glass OSD |
| `vscode/terminal-colors.json` | Monochrome ANSI colors for editor integrated terminal |
| `gtk-3.0/settings.ini` | Adwaita-dark, Colloid-Grey-Dark, Bibata 16 |
| `icons/Bibata-Modern-Classic/` | Bibata Modern Classic cursor included in theme |
| `icons/Colloid-Grey-Dark/` | Full icon theme included in theme (grey folders and apps) |
| `gtk-3.0/gtk.css` | caret-color, rounded inputs |
| `gtk-4.0/gtk.css` | caret-color |
| `walker/config.toml` | Centered, padding 80x300 |
| `walker/themes/custom/style.css` | 13px font, subtext on select, 84% box |
| `shaders/*.glsl` | Cursor shaders: Gentle-AI smear (default), blaze alternatives |
| `fish/config.fish` | Fish config (clean terminal on open) |
| `neovim.lua` | Monochrome colorscheme for Neovim (LazyVim) |

- `cursor-style = "block"` no blink + **cursor smear** Gentle-AI (`cursor_smear_gentleman.glsl`).
- Alternatives included: `cursor_blaze.glsl` (amber trail) and `cursor_blaze_2.glsl` (yellow tail, long jumps only).
- To change: edit `custom-shader` in `dotfiles/config` and reinstall.
