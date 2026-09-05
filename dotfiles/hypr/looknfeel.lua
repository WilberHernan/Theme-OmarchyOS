-- Theme OmarchyOS — looknfeel.lua
-- Apple-style animations for Hyprland 0.56 (Lua API)
--
-- NOTE: Hyprland "speed" = duration in 1/100s. LOWER = FASTER.
-- Fast + subtle overshoot bounce. This is the config the user confirmed
-- feels right ("me gustó mucho así").

hl.config({
  decoration = {
    rounding = 8,
    active_opacity = 0.80,
    inactive_opacity = 0.68,
    dim_inactive = true,
    dim_strength = 0.15,
    blur = {
      enabled = true,
      size = 2,
      passes = 1,
      new_optimizations = true,
      ignore_opacity = true,
      brightness = 0.68,
      contrast = 0.85,
    },
  },
})

hl.config({
  general = {
    border_size = 1,
    gaps_in = 3,
    gaps_out = { top = 6, right = 6, bottom = 6, left = 6 },
  },
})

hl.config({
  cursor = {
    enable_hyprcursor = false,
    hide_on_key_press = true,
  },
})

-- Fast easing curves
hl.curve("fastEaseOut", { type = "bezier", points = { { 0.16, 0 }, { 0.2, 1 } } })
hl.curve("fastEaseInOut", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("smooth", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

-- Overshoot: visible-but-tasteful Apple bounce (~10% past, quick settle)
hl.curve("overshoot", { type = "bezier", points = { { 0.32, 1.1 }, { 0.55, 1.0 } } })

-- Snappy spring with a balanced, subtle bounce
hl.curve("springApple", { type = "spring", mass = 1, stiffness = 620, dampening = 34 } )

-- Premium decelerate: arrives fast, decelerates elegantly into place.
-- Standard "expensive" easing (cubic-bezier 0.16,1,0.3,1) used across premium UI.
hl.curve("premiumEase", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })

-- Global baseline (fast)
hl.animation({ leaf = "global", enabled = true, speed = 4, bezier = "quick" })

-- Windows — fast open with subtle overshoot bounce
hl.animation({ leaf = "windows",       enabled = true, speed = 4, bezier = "overshoot" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 3, bezier = "overshoot", style = "popin 90%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 3, bezier = "fastEaseInOut", style = "popin 60%" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 4, spring = "springApple" })

-- Layers (dropdowns, panels)
hl.animation({ leaf = "layers",        enabled = true, speed = 4, bezier = "overshoot" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 3, bezier = "premiumEase", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 3, bezier = "fastEaseInOut", style = "fade" })

-- Fades
hl.animation({ leaf = "fade",          enabled = true, speed = 4, bezier = "quick" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 3, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 3, bezier = "fastEaseInOut" })
hl.animation({ leaf = "fadeSwitch",    enabled = true, speed = 4, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeShadow",    enabled = true, speed = 4, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeGlow",      enabled = true, speed = 4, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeDim",       enabled = true, speed = 4, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeLayers",    enabled = true, speed = 3, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 3, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 3, bezier = "fastEaseInOut" })
hl.animation({ leaf = "fadePopups",    enabled = true, speed = 3, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadePopupsIn",  enabled = true, speed = 3, bezier = "fastEaseOut" })
hl.animation({ leaf = "fadePopupsOut", enabled = true, speed = 3, bezier = "fastEaseInOut" })

-- Border
hl.animation({ leaf = "border",        enabled = true, speed = 6, bezier = "smooth" })
hl.animation({ leaf = "borderangle",   enabled = true, speed = 100, bezier = "linear", style = "loop" })

-- Workspaces
hl.animation({ leaf = "workspaces",        enabled = true, speed = 4, spring = "springApple", style = "slide" })
hl.animation({ leaf = "specialWorkspace",    enabled = true, speed = 4, spring = "springApple", style = "slidevert" })

-- Glass notification effect (mako layer namespace is "notifications")
-- Blurs the content behind the translucent card; ignore_alpha keeps the
-- rounded corners clean instead of showing a square blur patch.
hl.layer_rule({
  match = { namespace = "notifications" },
  blur = true,
  ignore_alpha = 0.4,
})

-- Notifications drop in from the top like an Apple banner (premium slide).
-- Uses the premium decelerate curve (via layersIn) for an elegant settle.
hl.layer_rule({
  match = { namespace = "notifications" },
  animation = "slide",
})

-- Walker launcher (layer namespace is "walker") — same blur as regular
-- windows so the launcher stays premium but readable: the app behind is
-- blurred (size 2 / passes 1) instead of showing through as sharp text.
hl.layer_rule({
  match = { namespace = "walker" },
  blur = true,
  ignore_alpha = 0.4,
})

-- Waybar (layer namespace is "waybar") — intentionally left without a blur
-- rule: user prefers the bar fully transparent with no frosted effect.
