--- A clickable button component.
-- @module Button
local GUI = ...
local Button = setmetatable({}, GUI.UIElement)
Button.__index = Button

--- Create a new Button.
-- @common_opts
-- @tparam[opt="Button"] string opts.text Button label
-- @tparam[opt] function opts.action Callback function on click
-- @tparam[opt=colours.white] number opts.bg_active Color when pressed
function Button:new(opts)
    local self = GUI.UIElement.new(self, opts) 
    self.text = opts.text or "Button"
    self.action = opts.action or function() end
    self.bg_active = opts.bg_active or colours.white
    self.fg_active = opts.fg_active or colours.black
    self.isPressed = false
    self.isBusy = false -- NEW: Lock to prevent re-entry
    self.revertTime = 0

    self.label = GUI.newLabel({
        mon = self.mon,
        x = self.x, y = self.y + math.floor(self.h / 2),
        w = self.w, h = 1,
        text = self.text,
        align = "center",
        bg = self.bg, fg = self.fg
    })
    return self
end

function Button:render()
    local m = self.mon
    local bg = (self.isPressed or self.isBusy) and self.bg_active or self.bg
    local fg = (self.isPressed or self.isBusy) and self.fg_active or self.fg

    m.setBackgroundColor(bg)
    for i = 0, self.h - 1 do
        m.setCursorPos(self.x, self.y + i)
        m.write((" "):rep(self.w))
    end

    self.label.bg = bg
    self.label.fg = fg
    self.label:render()
end

function Button:click()
    -- If we are already doing an action, ignore new clicks
    if self.isBusy then return end
    
    self.isBusy = true
    self.isPressed = true
    self.revertTime = os.clock() + 0.1
    self:render()
    
    -- Run action safely
    if self.action then 
        pcall(self.action) 
    end
    
    -- Unlock once the action (including sleeps) is finished
    self.isBusy = false
    self:render()
end

function Button:update()
    if self.isPressed and os.clock() >= self.revertTime then
        self.isPressed = false
        self:render()
    end
end

GUI.register("Button", Button)