# NexusUI Showcase Gallery

A comprehensive demonstration of all UI components in the framework.

---

## Setup

First, we require the manager and detect the monitor.  
We also define a helper function to handle the grid layout for our frames.

```lua
local GUI = require("lib.gui.manager")
local mon = peripheral.find("monitor") or term.current()

local frames = {}
local fw, fh = 26, 13
local pad = 1

local function makeFrame(col, row, title)
    local f = GUI.newFrame({
        x = (col-1)*(fw+pad)+2,
        y = (row-1)*(fh+pad)+2,
        w = fw,
        h = fh,
        text = title,
        bg = colours.black,
        bc = colours.grey,
        mon = mon
    })

    table.insert(frames, f)
    return f
end
```

---

## Labels & Alignment

Labels support multiple alignment modes.  
This example shows justified text with vertical centering.

```lua
local f1 = makeFrame(1, 1, "Label Alignments")

f1:addChild(GUI.newLabel({
    x = 2,
    y = 2,
    w = fw - 4,
    h = fh - 4,
    text = "Justified text looks very professional in boxes. This label is middle-aligned vertically.",
    align = "justify",
    vAlign = "middle",
    bg = colours.black,
    fg = colours.yellow,
    mon = f1.window
}))
```

---

## Interactive Buttons

Buttons include built-in state management for hover/active colours and callback actions.

```lua
local f2 = makeFrame(2, 1, "Buttons")

local statusLbl = f2:addChild(GUI.newLabel({
    x = 2,
    y = 8,
    w = fw - 4,
    text = "Waiting...",
    align = "center",
    mon = f2.window
}))

f2:addChild(GUI.newButton({
    x = 4,
    y = 3,
    w = 16,
    h = 3,
    text = "Click Me",
    bg = colours.blue,
    bg_active = colours.cyan,
    action = function()
        statusLbl:setText("Button Clicked!")
        os.sleep(0.5)
        statusLbl:setText("Waiting...")
    end,
    mon = f2.window
}))
```

---

## Input Fields

The Input element handles text entry, including support for masked password fields and placeholders.

```lua
local f3 = makeFrame(3, 1, "Inputs")

f3:addChild(GUI.newInput({
    x = 2,
    y = 3,
    w = fw - 4,
    placeholder = "Username",
    mon = f3.window
}))

f3:addChild(GUI.newInput({
    x = 2,
    y = 7,
    w = fw - 4,
    masked = true,
    placeholder = "Password",
    mon = f3.window
}))
```

---

## Dropdowns

Dropdowns expand when clicked to allow users to select an option from a predefined list.

```lua
local f4 = makeFrame(1, 2, "Selection")

f4:addChild(GUI.newDropdown({
    x = 2,
    y = 3,
    w = fw - 4,
    options = {
        "Option A",
        "Option B",
        "Option C",
        "Option D"
    },
    onSelect = function(val)
        print("Selected: " .. val)
    end,
    mon = f4.window
}))
```

---

## Initialisation

To run the UI, you must call `GUI.init`.  
This starts the event listener and update loop.

```lua
GUI.init({
    scale = 0.5,
    frames = frames,
    onUpdate = function()
        -- Dynamic logic goes here
    end
})
```