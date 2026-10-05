hl.config({
  animations = {
    enabled = true,
  },
})

hl.curve("easeOutQuart", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })
hl.curve("easeInOutSine", { type = "bezier", points = { { 0.37, 0 }, { 0.63, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4, bezier = "easeOutQuart" })
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "easeOutQuart", style = "popin" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "easeOutQuart", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "easeOutQuart", style = "popin" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "easeOutQuart", style = "popin" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "easeOutQuart", style = "slide" })
