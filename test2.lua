local GUI = require("lib.gui.manager")
local mon = peripheral.find("monitor") or term.current()

local frames = {}
local fw, fh = 26, 13
local pad = 1

-- Helper to layout frames in a grid
local function makeFrame(col, row, title)
    local f = GUI.newFrame({
        x = (col-1)*(fw+pad)+2, y = (row-1)*(fh+pad)+2,
        w = fw, h = fh, text = title,
        bg = colours.black, bc = colours.grey, mon = mon
    })
    table.insert(frames, f)
    return f
end

-- 1. LABELS & ALIGNMENT
local f1 = makeFrame(1, 1, "Typography")
f1:addChild(GUI.newLabel({
    x = 2, y = 2, w = fw-4, h = fh-4,
    text = "The quick brown fox jumps over the lazy dog. This text is justified and middle-aligned.",
    align = "justify", vAlign = "middle",
    bg = colours.black, fg = colours.yellow, mon = f1.window
}))

-- 2. BUTTONS & BLOCKING ACTIONS
local f2 = makeFrame(2, 1, "Logic Test")
local statusLbl = f2:addChild(GUI.newLabel({x=2, y=8, w=fw-4, text="Idle", align="center", mon=f2.window}))

f2:addChild(GUI.newButton({
    x = 4, y = 3, w = 16, h = 3, text = "Long Action",
    bg = colours.blue, bg_active = colours.cyan,
    action = function() 
        statusLbl:setText("Processing...")
        statusLbl.fg = colours.orange
        
        -- Testing the new non-blocking sleep
        GUI.sleep(2.0) 
        
        statusLbl:setText("Finished!")
        statusLbl.fg = colours.green
        GUI.sleep(1.0)
        statusLbl:setText("Idle")
        statusLbl.fg = colours.white
    end,
    mon = f2.window
}))

-- 3. INPUT FIELDS
local f3 = makeFrame(3, 1, "Input/Masking")
f3:addChild(GUI.newInput({
    x = 2, y = 3, w = fw-4, placeholder = "Username", mon = f3.window
}))
f3:addChild(GUI.newInput({
    x = 2, y = 7, w = fw-4, masked = true, placeholder = "Secret Key", mon = f3.window
}))

-- 4. DROPDOWNS
local f4 = makeFrame(1, 2, "Selection")
local selLbl = f4:addChild(GUI.newLabel({x=2, y=7, w=fw-4, text="Selected: None", align="center", mon=f4.window}))

f4:addChild(GUI.newDropdown({
    x = 2, y = 3, w = fw-4,
    options = {"Redstone", "Diamond", "Emerald", "Coal"},
    onSelect = function(val) 
        selLbl:setText("Selected: " .. val)
    end,
    mon = f4.window
}))

-- 5. PROGRESS BARS (Animated)
local f5 = makeFrame(2, 2, "Animations")
local pbH = f5:addChild(GUI.newProgressBar({
    x = 2, y = 3, w = fw-4, h = 3, value = 0, barColour = colours.red, mon = f5.window
}))
local pbV = f5:addChild(GUI.newProgressBar({
    x = 10, y = 7, w = 6, h = 4, value = 0, direction = "vertical", flipped = false, barColour = colours.purple, mon = f5.window
}))

-- 6. SYSTEM INFO (Real-time)
local f6 = makeFrame(3, 2, "System")
local timeLbl = f6:addChild(GUI.newLabel({x=2, y=4, w=fw-4, align="center", text="00:00", mon=f6.window}))
local dayLbl = f6:addChild(GUI.newLabel({x=2, y=6, w=fw-4, align="center", text="Day 0", fg=colours.lightGrey, mon=f6.window}))

-- INITIALIZE MANAGER
GUI.init({
    scale = 0.5,
    frames = frames,
    onUpdate = function()
        -- 1. Update Clock
        timeLbl:setText(textutils.formatTime(os.time(), true))
        dayLbl:setText("Day: " .. os.day())

        -- 2. Update Progress Bars (sine-wave style movement)
        local t = os.clock()
        pbH.value = (math.sin(t) + 1) * 50
        pbV.value = (math.cos(t) + 1) * 50
    end
})