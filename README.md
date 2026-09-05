# Theme OmarchyOS

Monochrome dark theme for Omarchy. Clean, modern, Bibata cursor.

## Dependencies

Install these once before the theme:

```bash
yay -S yaru-icon-theme nerd-fonts-jetbrains-mono
sudo pacman -S ghostty hyprlock 
```

> El cursor **Bibata-Modern-Classic** ya viene incluido en el theme (no necesita instalarse aparte).
> Las fuentes **Gunplay** e **Inter** vienen bundleadas en el theme (se instalan solas desde `fonts/`).
> `Adwaita-dark` viene con `gtk-engine`, ya debería estar instalado en Omarchy.
> `hyprlock` viene con Omarchy, pero si no lo tenés: `sudo pacman -S hyprlock`.
> `` reemplaza a  para el greeting con el  Gentle-AI.

## Install

```bash
omarchy theme install https://github.com/WilberHernan/Theme-OmarchyOS.git
omarchy theme set theme-omarchyos
~/.config/omarchy/themes/theme-omarchyos/setup.sh
```

**Cerrar sesión y volver a entrar** para que todo tome efecto.

> `setup.sh` hace **backup automático** de cualquier config que pise
> (`.bak-<timestamp>` junto al archivo). Re-ejecutarlo es seguro e idempotente.

## ⚠️ REGLAS DE ORO — leé esto antes de tocar el theme

Omarchy mantiene **TRES copias** de los archivos del theme. Los errores
"mágicos" (se perdió el blur, volvió el negro, el tema revirtió) casi siempre
vienen de actualizar UNA copia y olvidar las otras dos:

| Copia | Ruta | Quién la usa |
|---|---|---|
| 1. Repo (fuente de verdad) | `~/.config/omarchy/themes/theme-omarchyos/` | git, backup, instalación en otra PC |
| 2. Plantilla activa | `~/.config/omarchy/current/theme/` | Omarchy la copia completo al **re-aplicar** el theme |
| 3. Configs vivos | `~/.config/hypr/`, `~/.config/walker/`, `~/.config/waybar/`, etc. | El sistema corre con esto |

**Cuando cambies algo, sincronizá las 3 copias:**
```bash
T=~/.config/omarchy/themes/theme-omarchyos
C=~/.config/omarchy/current/theme
cp <archivo-cambiado> "$T/..." && cp <archivo-cambiado> "$C/..."
```

- Si editás **solo el repo** → el próximo `omarchy theme set` vuelve a la
  versión vieja y "pierde" tu trabajo.
- Si editás **solo la copia viva** → se pierde al re-aplicar o reinstalar.
- `setup.sh` solo copia DESDE el repo HACIA los configs vivos: los archivos
  que omarchy maneja (loader `hyprland.lua`, `config.jsonc` de waybar) **no
  se tocan** y pertenecen a Omarchy, no al theme.

## Errores conocidos y cómo se solucionaron (no repetirlos)

| Error | Causa | Fix aplicado |
|---|---|---|
| Walker se veía negro sin blur | La layer rule de blur vivía solo en la copia viva y el repo; `current/theme` no la tenía → al re-aplicar, la perdía | Regla `hl.layer_rule` (walker + notificaciones) en `looknfeel.lua` sincronizada en las 3 copias |
| Waybar como franja oscura | Tenía 0.55 de opacidad pero **sin blur** → se veía un rectángulo opaco | Probamos blur + glass (commit `49eabb1`), luego el usuario decidió: **waybar 100% transparente, sin blur** (commit `6548fd0`) |
| Ocultar el input de búsqueda del walker | Falla: ni `display:none` css ni el flag nativo `-n/--nosearch` lo ocultan de forma confiable; además `--nosearch` rompía el flujo del servicio | **Revertido** (commit `7d5c98d`). No volver a intentarlo |
| `mako.ini` raíz viejo (sólido `#121212`) | Omarchy consume `mako.ini` de la raíz al re-aplicar → hacía retroceder el glass de notificaciones | Actualizado al mismo glass que `dotfiles/mako/config` |
| Cursor 20 vs 16 | `current/theme` estaba congelado con cursor 20; el sistema usa 16 | Sincronizado `envs.lua` + `uwsm/env` a cursor 16 en las 3 copias |

### Comandos seguros

- Reiniciar walker: `omarchy-restart-walker` (NO `nohup walker` directo — rompe el `@import` del CSS por HOME incorrecto).
- Reiniciar waybar: `omarchy-restart-waybar`.
- Recargar una regla de Hyprland al vuelo: `hyprctl eval '...'` (el `hyprctl reload` **no** re-evalúa el Lua de `looknfeel.lua`).
- Restaurar desde `current/theme` sin tocar el repo: `omarchy theme set theme-omarchyos` (usa la copia 2 tal cual está).

## What `setup.sh` does

- Copia `looknfeel.lua` (11 animaciones spring/bezier, rounding 8, blur layer rules)
- Copia `envs.lua` (variables de cursor 16)
- Copia `hyprlock.conf` (reloj estilo Hyadum, input invisible, desbloqueo animado)
- Copia `uwsm/env` (variables de cursor persistentes entre sesiones)
- Copia `waybar/style.css` (Inter 11, sin bold, **transparente, sin blur**)
- **No** toca `waybar/config.jsonc` (módulos) — es de Omarchy; los módulos y el clima se quitan/editan a mano
- Copia `mako/config` (glass, top-center, banner pegado arriba)
- Copia `swayosd/` (OSD premium glass)
- Copia configs de terminales (Alacritty, Kitty, Ghostty) + shaders del cursor (smear Gentle-AI)
- Copia `gtk-3.0/` y `gtk-4.0/` (tema, iconos, cursor, inputs redondeados)
- Copia `icons/` (cursor Bibata-Modern-Classic)
- Copia `walker/` (centrado, 13px, subtexto al seleccionar)
- Copia `/` (config + logo  Gentle-AI) e instala el  en `~/.config/omarchy/branding/`
- Copia `fish/config.fish` ( al abrir terminal)
- Instala las fuentes **Gunplay** (reloj del lockscreen) e **Inter** (interfaz)
- Copia script de bloqueo propio (15s antes de apagar pantalla)
- Setea Ghostty como terminal default
- Enlaza settings de code-oss → VS Code (para que el colorTheme aplique en code-oss)
- Fusiona colores monocromos en la terminal integrada del editor (`dotfiles/vscode/terminal-colors.json`)
- Aplica `gsettings` (cursor Bibata 16, fuentes Inter 10.5 / JetBrainsMono 10, window theme)

## Lockscreen

- Reloj con fuente **Gunplay** estilo Hyadum (hora grande centrada)
- **Sin campo de contraseña visible** — solo escribís y desbloqueás
- Animación suave al bloquear y desbloquear (fade, curva apple)
- La pantalla se apaga a los **15 segundos** de bloqueada

## Dotfiles

| Archivo | Qué hace |
|---|---|
| `hypr/hyprland.lua` | Loader gestionado por Omarchy (no se incluye en el theme) |
| `hypr/envs.lua` | `XCURSOR_THEME`, `HYPRCURSOR_THEME`, tamaño 16 |
| `hypr/looknfeel.lua` | 4 curvas, 11 animaciones, rounding 8, blur layer rules |
| `hypr/hyprlock.conf` | Lockscreen Hyadum-style: Gunplay clock, fade animation |
| `scripts/omarchy-system-lock` | Lock propio: 15s display-off delay |
| `fonts/Gunplay_Regular.otf` | Fuente Gunplay bundleada para el reloj |
| `fonts/Inter-VariableFont_slnt,wght.ttf` | Fuente Inter UI bundleada |
| `uwsm/env` | Cursor envs persistentes via UWSM |
| `waybar/style.css` | Wrapper del usuario que hace `@import` a los colores del theme |
| `mako/config` | Notificaciones glass, top-center, banner pegado arriba |
| `swayosd/style.css` | OSD premium glass |
| `vscode/terminal-colors.json` | Colores ANSI monocromos para la terminal integrada del editor |
| `gtk-3.0/settings.ini` | Adwaita-dark, Yaru-red-dark, Bibata 16 |
| `icons/Bibata-Modern-Classic/` | Cursor Bibata Modern Classic incluido en el theme |
| `gtk-3.0/gtk.css` | caret-color, inputs redondeados |
| `gtk-4.0/gtk.css` | caret-color |
| `walker/config.toml` | Centrado, padding 80x300 |
| `walker/themes/custom/style.css` | 13px font, subtext en select, 84% box |
| `/.txt` | Logo  Gentle-AI (braille, sin color) → `~/.config/omarchy/branding/` |
| `/config.jsonc` | Info centrada verticalmente, iconos, sin dos puntos |
| `shaders/*.glsl` | Shaders cursor: smear Gentle-AI (default), blaze alternativos |
| `fish/config.fish` |  con  al abrir terminal |

***REMOVED***

***REMOVED***
***REMOVED***
- El logo se renderiza con la fuente del terminal (JetBrainsMono Nerd Font). Si querés el braille más grueso: `FantasqueSansM Nerd Font`.
***REMOVED***

## Cursor (Ghostty)

- `cursor-style = "block"` sin blink + **cursor smear** Gentle-AI (`cursor_smear_gentleman.glsl`).
- Alternativas incluidas: `cursor_blaze.glsl` (estela ámbar) y `cursor_blaze_2.glsl` (cola amarilla, solo saltos largos).
- Para cambiar: editá `custom-shader` en `dotfiles/config` y reinstalá.

## Estructura del glass (look actual)

| Componente | Fondo | Blur | Borde |
|---|---|---|---|
| Walker launcher | `rgba(18,18,18,0.55)` | Sí (layer rule `walker`, `ignore_alpha=0.4`) | `rgba(255,255,255,0.14)` |
| Notificaciones (mako) | `rgba(30,30,30,0.50)` | Sí | sin borde, radio 12 |
| OSD (swayosd) | `rgba(18,18,18,0.55)` | No (ventana pequeña) | `rgba(255,255,255,0.10)` |
| Waybar | **transparente (alpha 0)** | **No** | sin borde |