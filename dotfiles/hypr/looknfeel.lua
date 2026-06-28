hl.config({
  decoration = {
    rounding = 8,
  },
})

hl.curve("natural", { type = "spring", mass = 1, stiffness = 80, dampening = 15 })
hl.curve("smooth", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 6, spring = "natural", style = "popin 85%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 6, spring = "natural" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 4, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 4, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 4, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "easeOutExpo" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "smooth" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "loop" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, spring = "natural", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 7, spring = "natural", style = "slidevert" })
