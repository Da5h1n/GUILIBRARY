--- Text input field for user entry with focus and masking support.
-- @module Input
local GUI = ...


local Input = setmetatable({}, GUI.UIElement)
Input.__index = Input

--- Creates a new Input field instance.
-- @tparam table opts Options include placeholder, maxLen, masked, and maskChar.
function Input:new(opts)
    local self = GUI.UIElement.new(self, opts)

    self.h = opts.h or 1

    self.text = opts.text or ""
    self.maxLen = opts.maxLen or 20
    self.placeholder = opts.placeholder or "Type here..."
    self.onSubmit = opts.onSubmit or function(text) end

    self.maskChar = opts.maskChar or "*"
    self.masked = opts.masked or false
    self.showToggle = opts.showToggle ~= false
    self.isUnmasked = false

    self.cursorChar = opts.cursorChar or "_"
    self.showCursor = false
    self.cursorTimer = 0
    self.focused = false

    self.textLabel = GUI.newLabel({
        mon = self.mon, x = self.x, y = self.y,
        w = self.showToggle and (self.w - 2) or self.w, h = 1,
        text = "", align = "left", bg = self.bg, fg = self.fg
    })

    if self.masked and self.showToggle then
        self.toggleBtn = GUI.newButton({
            mon = self.mon, x = self.x + self.w - 2, y = self.y,
            w = 1, h = 1, text = "X", bg = colours.grey, fg = colours.white,
            action = function()
                self.isUnmasked = not self.isUnmasked
                self.toggleBtn.text = self.isUnmasked and "O" or "X"
                self:render()
            end
        })
    end

    return self
end

function Input:render()
    local m = self.mon
    local displayText = self.text

    if #displayText == 0 then
        self.textLabel.fg = colours.lightGrey
        self.textLabel.text = self.placeholder
    else
        self.textLabel.fg = self.fg
        if self.masked and not self.isUnmasked then
            self.textLabel.text = (self.maskChar):rep(#displayText)
        else
            self.textLabel.text = displayText
        end
    end

    self.textLabel:render()

    if self.focused and self.showCursor and #self.text < self.textLabel.w then
        m.setCursorPos(self.x + #self.text, self.y)
        m.setTextColor(self.fg)
        m.write(self.cursorChar)
    end
    
    if self.toggleBtn then self.toggleBtn:render() end
end

--- Internal update loop for handling cursor blinking.
-- @internal
function Input:update()
    if self.focused then
        if os.clock() - self.cursorTimer > 0.5 then
            self.showCursor = not self.showCursor
            self.cursorTimer = os.clock()
            self:render()
        end
    end
end

function Input:click(x, y)
    if self.toggleBtn and x == self.toggleBtn.x and y == self.toggleBtn.y then
        self.toggleBtn:click()
        return
    end

    if GUI.focusedElement and GUI.focusedElement ~= self then
        GUI.focusedElement.focused = false
        GUI.focusedElement:render()
    end

    GUI.focusedElement = self
    self.focused = true
    self.cursorTimer = os.clock()
    self.showCursor = true
    self:render()
end

--- Captures focus and handles character/key events.
-- @tparam table event The ComputerCraft event table.
function Input:onType(event)
    local e = event[1]

    if e == "char" then
        local char = event[2]
        if #self.text < self.maxLen then
            self.text = self.text .. char
            self.showCursor = true
        end

    elseif e == "paste" then
        local text = event[2]

        if #self.text + #text <= self.maxLen then
            self.text = self.text .. text
        end

    elseif e == "key" then
        local key = event[2]
        if key == keys.backspace then
            if #self.text > 0 then
                self.text = self.text:sub(1, -2)
                self.showCursor = true
            end
        elseif key == keys.enter then
            self.focused = false
            GUI.focusedElement = nil
            self.showCursor = false
            self:render()
            if self.onSubmit then self.onSubmit(self.text) end
            return
        end
    end

    self:render()
end

GUI.register("Input", Input)