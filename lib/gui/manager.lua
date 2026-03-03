--- The core engine of the UI framework. Handles element registration,
-- event looping, and global focus management.
-- @module Manager
local Manager = {}

-- @internal
Manager.classes = {}
Manager.activeFrames = {}
Manager.focusedElement = nil
Manager.lastTick = 0
Manager.onUpdate = nil
Manager.timerID = nil -- NEW: Global timer ID

--- Registers a new UI class and creates a shortcut constructor.
-- For example, registering "Button" creates `Manager.newButton()`.
-- @tparam string name The name of the class
-- @tparam table classTable The table containing the class methods
function Manager.register(name, classTable)
    Manager.classes[name] = classTable
    Manager["new" .. name] = function(opts)
        return classTable:new(opts)
    end
end

--- Base class for all UI components.
-- @section UIElement

--- The base UI element class that all components inherit from.
-- @table UIElement
Manager.UIElement = {}
Manager.UIElement.__index = Manager.UIElement

--- Base UI element properties.
-- All UI components (Buttons, Labels, etc.) inherit these fields.
-- @table UIElement
-- @tparam[opt] string id Unique identifier for the element
-- @tparam[opt=1] number x X coordinate
-- @tparam[opt=1] number y Y coordinate
-- @tparam[opt=18] number x Width
-- @tparam[opt=12] number h Height
-- @tparam[opt=colours.blue] number bg Background color
-- @tparam[opt=colours.white] number fg Foreground color
-- @tparam[opt=term] table mon The display target (monitor or term)
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

function Manager.resetTimer()
    Manager.timerID = os.startTimer(0.1)
end

--- The main way to wait without blocking other UI updates.
-- @tparam number duration The seconds to wait before continuing.
function Manager.sleep(duration)
    local target = os.clock() + duration
    local sleepTimer = os.startTimer(duration)

    while os.clock() < target do
        local event = {os.pullEvent()}
        local e = event[1]

        if e == "timer" then
            if event[2] == sleepTimer then
                break 
            elseif event[2] == Manager.timerID then
                runUpdateTick()
                Manager.resetTimer()
            end
        elseif e == "monitor_resize" then
            for _, f in ipairs(Manager.activeFrames) do f:render(true) end
        end

        if os.clock() - Manager.lastTick >= 0.15 then
            runUpdateTick()
            Manager.resetTimer()
        end
    end
end


--- Core Loop.
-- @section Main

--- Initializes the framework and starts the event listener loop.
-- This function is blocking (yields).
-- @tparam table config Configuration table
-- @tparam table config.frames List of frames to display
-- @tparam[opt=0.5] number config.scale Text scale for the monitor
-- @tparam[opt] function config.onUpdate Function called every tick (0.1s)
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


-- Everything below this line is the internal file loader.
-- We don't annotate these because the user never calls them.
-- @section Internal
-- @internal
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