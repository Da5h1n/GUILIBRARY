local Flux = require("lib.gui.Flux")

-- Define a button directly on the main screen
local myButton = Flux.newButton({
    x = 2, y = 2,
    w = 10, h = 3,
    text = "Click Me",
    bg = colours.red,
    action = function()
        term.setCursorPos(1,5)
        print("Button clicked!")
    end
})

-- Initialize Flux with the button directly
Flux.init({
    frames = { myButton }
})