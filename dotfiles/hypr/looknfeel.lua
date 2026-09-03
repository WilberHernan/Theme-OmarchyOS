-- Theme OmarchyOS — looknfeel.lua
-- Fast, productive Apple-style animations for Hyprland 0.56 (Lua API)
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

-- Fast, crisp easing curves (short settle, no laggy tail)
hl.curve("fastEaseOut", { type = "bezier", points = { { 0.16, 0 }, { 0.2, 1 } } })
hl.curve("fastEaseInOut", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("smooth", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

-- Snappy spring: high stiffness = fast, moderate dampening = minimal bounce
hl.curve("snappy", { type = "spring", mass = 1, stiffness = 700, dampening = 90 } )

-- Global baseline
hl.animation({ leaf = "global", enabled = true, speed = 20, bezier = "quick" })

-- Windows — fast open / close, feels instant but polished
hl.animation({ leaf = "windows",       enabled = true, speed = 15, bezier = "fastEaseOut" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 15, bezier = "fastEaseOut", style = "popin 90%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 12, bezier = "fastEaseInOut", style = "popin 60%" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 18, spring = "snappy" })

-- Layers (dropdowns, panels)
hl.animation({ leaf = "layers",        enabled = true, speed = 12, bezier = "fastEaseOut" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 12, bezier = "fastEaseOut", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 10, bezier = "fastEaseInOut", style = "fade" })

-- Fades
hl.animation({ leaf = "fade",          enabled = true, speed = 12, bezier = "quick" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 10, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 8, bezier = "fastEaseInOut" })
hl.animation({ leaf = "fadeSwitch",    enabled = true, speed = 12, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeShadow",    enabled = true, speed = 12, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeGlow",      enabled = true, speed = 12, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeDim",       enabled = true, speed = 10, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeLayers",    enabled = true, speed = 8, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 8, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 6, bezier = "fastEaseInOut" })
hl.animation({ leaf = "fadePopups",    enabled = true, speed = 8, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadePopupsIn",  enabled = true, speed = 8, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadePopupsOut", enabled = true, speed = 6, bezier = "fastEaseInOut" })

-- Border
hl.animation({ leaf = "border",        enabled = true, speed = 15, bezier = "smooth" })
hl.animation({ leaf = "borderangle",   enabled = true, speed = 100, bezier = "linear", style = "loop" })

-- Workspaces
hl.animation({ leaf = "workspaces",        enabled = true, speed = 14, spring = "snappy", style = "slide" })
hl.animation({ leaf = "specialWorkspace",    enabled = true, speed = 14, spring = "snappy", style = "slidevert" })
