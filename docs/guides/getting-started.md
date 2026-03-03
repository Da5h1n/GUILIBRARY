# Getting Started

This guide will help you get started with Flux and build your first user interface.

## Installation

Flux is a library for ComputerCraft. Download `PLACEHOLDER` and place it in your ComputerCraft computer.

```lua
-- Download the installer using wget
wget run "PLACEHOLDER"
```

## Your First Application

Let's create a simple application with a button:

```lua
local flux = require("Flux")

--Create the button
local button = flux.newButton({
    x = 5,
    y = 5,
    w = 15,
    h = 3,
    text = "Action",
    bg = colours.blue,
    fg = colours.white,
    bg_active = colours.cyan,
    fg_active = colours.black,
    action = function()
        print("Button Clicked")
    end
})

-- Initialise the UI
flux.init({
    scale = 0.5 -- set the scale of the terminal
    frames = { button }
})
```

## Understanding the Structure

CONTINUE DOCS HERE!