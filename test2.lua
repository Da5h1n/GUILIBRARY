local GUI = require("lib.gui.manager")
local mon = peripheral.find("monitor") or term.current()

local frames = {}
local fw, fh = 26, 13
local pad = 1

local function makeFrame(col, row, title)
    local f = GUI.newFrame({
        x = (col-1)*(fw+pad)+2, y = (row-1)*(fh+pad)+2,
        w = fw, h = fh, text = title,
        bg = colours.black, bc = colours.grey, mon = mon
    })
    table.insert(frames, f)
    return f
end

-- FRAME 1: Text Alignments
local f1 = makeFrame(1, 1, "Label Alignments")
f1:addChild(GUI.newLabel({
    x = 2, y = 2, w = fw-4, h = fh-4,
    text = "Justified text looks very professional in boxes. This label is middle-aligned vertically.",
    align = "justify", vAlign = "middle",
    bg = colours.black, fg = colours.yellow, mon = f1.window
}))

-- FRAME 2: Interactive Buttons
local f2 = makeFrame(2, 1, "Buttons")
local btnStatus = "Waiting..."
local statusLbl = f2:addChild(GUI.newLabel({x=2, y=8, w=fw-4, text=btnStatus, align="center", mon=f2.window}))

f2:addChild(GUI.newButton({
    x = 4, y = 3, w = 16, h = 3, text = "Click Me",
    bg = colours.blue, bg_active = colours.cyan,
    action = function() 
        statusLbl:setText("Button Clicked!")
        os.sleep(0.5)
        statusLbl:setText("Waiting...")
    end,
    mon = f2.window
}))

-- FRAME 3: Input Fields
local f3 = makeFrame(3, 1, "Inputs")
f3:addChild(GUI.newInput({
    x = 2, y = 3, w = fw-4, placeholder = "Username", mon = f3.window
}))
f3:addChild(GUI.newInput({
    x = 2, y = 7, w = fw-4, masked = true, placeholder = "Password", mon = f3.window
}))

-- FRAME 4: Dropdowns
local f4 = makeFrame(1, 2, "Selection")
f4:addChild(GUI.newDropdown({
    x = 2, y = 3, w = fw-4,
    options = {"Option A", "Option B", "Option C", "Option D"},
    onSelect = function(val) print("Selected: "..val) end,
    mon = f4.window
}))

-- FRAME 5: Progress Bars
local f5 = makeFrame(2, 2, "Progress")
local pb = f5:addChild(GUI.newProgressBar({
    x = 2, y = 3, w = fw-4, h = 3, value = 0, barColour = colours.green, mon = f5.window
}))
local pbVert = f5:addChild(GUI.newProgressBar({
    x = 2, y = 7, w = 4, h = 4, value = 75, direction = "vertical", flipped = true, mon = f5.window
}))

-- FRAME 6: Dynamic Updates
local f6 = makeFrame(3, 2, "System Info")
local timeLbl = f6:addChild(GUI.newLabel({x=2, y=5, w=fw-4, align="center", text="00:00", mon=f6.window}))

-- Init and Loop
GUI.init({
    scale = 0.5,
    frames = frames,
    onUpdate = function()
        timeLbl:setText(textutils.formatTime(os.time(), true))
        pb.value = (pb.value + 1) % 100
        pbVert.value = (pb.value + 1) % 100
    end
})