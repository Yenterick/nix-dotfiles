hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "12")

hl.config({
    decoration = {
        inactive_opacity = 0.75,
        rounding = 0,
    },
    general = {
        allow_tearing = true,
        gaps_out = { top = 6, right = 10, bottom = 10, left = 10 },
    },
})

hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.0}, {0.35, 1.0} } })

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 5.3,
    bezier = "easeInOutCubic",
    style = "slide",
})
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 1.5,
    bezier = "almostLinear",
    style = "slide",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "linear",
    style = "slide",
})
hl.animation({
    leaf = "borderangle",
    enabled = false,
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1.4,
    bezier = "almostLinear",
    style = "slide",
})
hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 1.21,
    bezier = "easeInOutCubic",
    style = "slide",
})
hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 1.94,
    bezier = "easeInOutCubic",
    style = "slide",
})
