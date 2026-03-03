local Manager = {}

Manager.classes = {}
Manager.activeFrames = {}
Manager.focusedElement = nil
Manager.lastTick = 0
Manager.onUpdate = nil
Manager.timerID = nil -- NEW: Global timer ID

function Manager.register(name, classTable)
    Manager.classes[name] = classTable
    Manager["new" .. name] = function(opts)
        return classTable:new(opts)
    end
end

Manager.UIElement = {}
Manager.UIElement.__index = Manager.UIElement

function Manager.UIElement:new(opts)
    local self = setmetatable({}, self)
    self.id = opts.id
    self.x = opts.x or 1
    self.y = opts.y or 1
    self.w = opts.w or 18
    self.h = opts.h or 12
    self.bg = opts.bg or colours.blue
    self.fg = opts.fg or colours.white
    self.bc = opts.bc or colours.lightGrey
    self.mon = opts.parent or opts.mon or term
    self.children = {}
    return self
end

local function runUpdateTick()
    if Manager.onUpdate then Manager.onUpdate() end

    for _, frame in ipairs(Manager.activeFrames) do
        if frame.update then frame:update() end
        for _, child in ipairs(frame.children or {}) do
            if child.update then child:update() end
        end
    end

    for _, f in ipairs(Manager.activeFrames) do
        f:render(false)
    end
    Manager.lastTick = os.clock()
end

-- NEW: Helper to restart the heartbeat
function Manager.resetTimer()
    Manager.timerID = os.startTimer(0.1)
end

function Manager.sleep(duration)
    local target = os.clock() + duration
    local sleepTimer = os.startTimer(duration)

    while os.clock() < target do
        local event = {os.pullEvent()}
        local e = event[1]

        if e == "timer" then
            if event[2] == sleepTimer then
                break -- Duration reached
            elseif event[2] == Manager.timerID then
                runUpdateTick()
                Manager.resetTimer() -- Keep heartbeat alive DURING sleep
            end
        elseif e == "monitor_resize" then
            for _, f in ipairs(Manager.activeFrames) do f:render(true) end
        end
        -- Fallback if events are slow
        if os.clock() - Manager.lastTick >= 0.15 then
            runUpdateTick()
            Manager.resetTimer()
        end
    end
end

function Manager.init(config)
    local frames = config.frames or config
    Manager.activeFrames = frames
    Manager.onUpdate = config.onUpdate
    local scale = config.scale or 0.5

    local mainMon = frames[1].mon
    if mainMon.setTextScale then mainMon.setTextScale(scale) end

    local function redraw()
        mainMon.setBackgroundColor(colours.black)
        mainMon.clear()
        for _, f in ipairs(Manager.activeFrames) do f:render(true) end
    end

    redraw()
    Manager.resetTimer() -- Start the first heartbeat

    while true do
        local event = {os.pullEvent()}
        local e = event[1]

        if e == "mouse_click" or e == "monitor_touch" then
            local _, side, x, y = table.unpack(event)
            local clickedSomething = false
            for _, f in ipairs(Manager.activeFrames) do
                if x >= f.x and x < f.x + f.w and y >= f.y and y < f.y + f.h then
                    if f.click then f:click(x, y) clickedSomething = true end
                end
            end

            if not clickedSomething and Manager.focusedElement then
                Manager.focusedElement.focused = false
                Manager.focusedElement:render()
                Manager.focusedElement = nil
            end

        elseif (e == "char" or e == "key" or e == "paste") then
            if Manager.focusedElement and Manager.focusedElement.onType then
                Manager.focusedElement:onType(event)
            end

        elseif e == "monitor_resize" then
            redraw()
        
        elseif e == "timer" and event[2] == Manager.timerID then
            runUpdateTick()
            Manager.resetTimer()
        end

        -- Self-healing check: if we've missed our timer, force a tick
        if os.clock() - Manager.lastTick >= 0.2 then
            runUpdateTick()
            Manager.resetTimer()
        end
    end
end

-- Loader
local classDir = "lib/gui/elements"
if fs.exists(classDir) and fs.isDir(classDir) then
    local files = fs.list(classDir)
    table.sort(files)
    for _, file in ipairs(files) do
        local path = classDir .. "/" .. file
        local chunk = loadfile(path)  
        if chunk then
            setfenv(chunk, _G)     
            pcall(chunk, Manager)          
        end
    end
end

return Manager