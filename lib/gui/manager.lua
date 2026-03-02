--- The core engine of the UI framework. Handles element registration, 
-- event looping, and global focus management.
-- @module Manager
local Manager = {}

--- The registry of all loaded UI classes.
-- @table classes
Manager.classes = {}

--- Currently active and visible frames.
-- @table activeFrames
Manager.activeFrames = {}

--- The element currently capturing keyboard input.
-- @type UIElement
Manager.focusedElement = nil


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

--- Constructor for the base UIElement.
-- @tparam table opts Configuration options
-- @tparam string opts.id Unique identifier for the element
-- @tparam[opt=1] number opts.x X coordinate
-- @tparam[opt=1] number opts.y Y coordinate
-- @tparam[opt=18] number opts.w Width
-- @tparam[opt=12] number opts.h Height
-- @tparam[opt=colours.blue] number opts.bg Background color
-- @tparam[opt=colours.white] number opts.fg Foreground color
-- @treturn UIElement
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

--- Utility functions.
-- @section Utility

--- Finds an element or frame by its string ID.
-- @tparam string id The ID to search for
-- @treturn UIElement|nil Returns the element if found, otherwise nil
function Manager.getByID(id)
    if not id then return nil end
    for _, f in ipairs(Manager.activeFrames) do
        if f.id == id then return f end
        for _, child in ipairs(f.children or {}) do
            if child.id == id then return child end
        end
    end
    return nil
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
    local scale = config.scale or 0.5

    local mainMon = frames[1].mon
    if mainMon.setTextScale then mainMon.setTextScale(scale) end

    local function redraw()
        mainMon.setBackgroundColor(colours.black)
        mainMon.clear()
        for _, f in ipairs(Manager.activeFrames) do f:render(true) end
    end

    redraw()

    while true do
        local timerID = os.startTimer(0.1)
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
        end

        if config.onUpdate then
            config.onUpdate()
        end

        for _, frame in ipairs(Manager.activeFrames) do
            if frame.update then frame:update() end
            for _, child in ipairs(frame.children or {}) do
                if child.update then child:update() end
            end
        end

        for _, f in ipairs(Manager.activeFrames) do
            f:render(false)
        end
    end
end

local classDir = "lib/gui/elements"

if fs.exists(classDir) and fs.isDir(classDir) then
    local files = fs.list(classDir)
    table.sort(files)
    
    for _, file in ipairs(files) do
        local path = classDir .. "/" .. file
        local chunk, err = loadfile(path)
        
        if chunk then
            -- 1. Use the standard global environment
            setfenv(chunk, _G) 
            
            -- 2. Pass the Manager (this table) as an argument to the chunk
            local success, runErr = pcall(chunk, Manager) 
            
            if not success then
                print("Error running " .. file .. ": " .. runErr)
            end
        else
            print("Error loading " .. file .. ": " .. err)
        end
    end
end

return Manager