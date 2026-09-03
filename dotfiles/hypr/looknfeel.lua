-- Theme OmarchyOS — looknfeel.lua
-- Apple-style animations for Hyprland 0.56 (Lua API)
-- Overrides the (slower) Omarchy defaults by defining every sub-leaf explicitly.

hl.config({
  decoration = {
    rounding = 8,
    active_opacity = 0.84,
    inactive_opacity = 0.72,
    dim_inactive = true,
    dim_strength = 0.15,
  },
})

hl.config({
  cursor = {
    enable_hyprcursor = false,
    hide_on_key_press = true,
  },
})

-- Apple-style easing curves
hl.curve("appleEaseOut", { type = "bezier", points = { { 0.45, 0.0 }, { 0.15, 1.0 } } })   -- open windows
hl.curve("appleEaseInOut", { type = "bezier", points = { { 0.32, 0.72 }, { 0, 0.84 } } })   -- close/hide
hl.curve("overshoot", { type = "bezier", points = { { 0.5, 0.9 }, { 0.1, 1.1 } } })          -- subtle bounce
hl.curve("smooth", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Firm spring for genuine "native" motion
hl.curve("snappy", { type = "spring", mass = 1, stiffness = 320, dampening = 28 } )

-- Global baseline
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "quick" })

-- Windows — separate open / close for a crisp Apple feel
hl.animation({ leaf = "windows",       enabled = true, speed = 9, bezier = "appleEaseOut" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 9, bezier = "appleEaseOut", style = "popin 80%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 6, bezier = "appleEaseInOut", style = "popin 50%" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 9, spring = "snappy" })

-- Layers (dropdowns, panels)
hl.animation({ leaf = "layers",        enabled = true, speed = 7, bezier = "appleEaseOut" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 7, bezier = "appleEaseOut", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 5, bezier = "appleEaseInOut", style = "fade" })

-- Fades
hl.animation({ leaf = "fade",          enabled = true, speed = 5, bezier = "quick" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 5, bezier = "appleEaseOut" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 4, bezier = "appleEaseInOut" })
hl.animation({ leaf = "fadeSwitch",    enabled = true, speed = 6, bezier = "appleEaseOut" })
hl.animation({ leaf = "fadeShadow",    enabled = true, speed = 6, bezier = "appleEaseOut" })
hl.animation({ leaf = "fadeGlow",      enabled = true, speed = 6, bezier = "appleEaseOut" })
hl.animation({ leaf = "fadeDim",       enabled = true, speed = 5, bezier = "appleEaseOut" })
hl.animation({ leaf = "fadeLayers",    enabled = true, speed = 4, bezier = "appleEaseOut" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 4, bezier = "appleEaseOut" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 3, bezier = "appleEaseInOut" })
hl.animation({ leaf = "fadePopups",    enabled = true, speed = 4, bezier = "appleEaseOut" })
hl.animation({ leaf = "fadePopupsIn",  enabled = true, speed = 4, bezier = "appleEaseOut" })
hl.animation({ leaf = "fadePopupsOut", enabled = true, speed = 3, bezier = "appleEaseInOut" })

-- Border
hl.animation({ leaf = "border",        enabled = true, speed = 10, bezier = "smooth" })
hl.animation({ leaf = "borderangle",   enabled = true, speed = 100, bezier = "linear", style = "loop" })

-- Workspaces
hl.animation({ leaf = "workspaces",        enabled = true, speed = 8, spring = "snappy", style = "slide" })
hl.animation({ leaf = "specialWorkspace",    enabled = true, speed = 8, spring = "snappy", style = "slidevert" })
