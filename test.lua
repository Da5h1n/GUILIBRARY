local GUI = require("lib.gui.Flux")
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

-- 3. INPUT/MASKING
local f3 = makeFrame(1, 1, "Input/Masking")
f3:addChild(GUI.newInput({ x = 2, y = 3, w = fw-4, placeholder = "Username", mon = f3.window }))
f3:addChild(GUI.newInput({ x = 2, y = 7, w = fw-4, masked = true, placeholder = "Secret Key", mon = f3.window }))


-- INITIALIZE
GUI.init({
    scale = 0.5,
    frames = frames
})