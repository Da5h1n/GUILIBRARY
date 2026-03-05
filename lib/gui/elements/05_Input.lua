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
    self.cursorIndex = #self.text
    self.scrollOffset = 0

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

function Input:updateScroll()
    local veiwW = self.textLabel.w

    if self.cursorIndex - self.scrollOffset >= veiwW then
        self.scrollOffset = self.cursorIndex - veiwW + 1
    end

    if self.cursorIndex < self.scrollOffset then
        self.scrollOffset = self.cursorIndex
    end
end

function Input:render()
    local m = self.mon
    local rawText = self.text
    
    -- Determine the state: Editing (Manual Window) vs Idle (Label Marquee)
    if self.focused then
        self:updateScroll()
        
        -- Disable Label's internal marquee logic so it doesn't fight our cursor
        self.textLabel.scroll = false 
        self.textLabel.scrollOffset = 0 

        local procText = rawText
        if #rawText == 0 then
            self.textLabel.fg = colours.lightGrey
            self.textLabel.text = self.placeholder
        else
            self.textLabel.fg = self.fg
            if self.masked and not self.isUnmasked then
                procText = (self.maskChar):rep(#rawText)
            end
            -- We manually "scroll" by sending a substring to the Label
            self.textLabel.text = procText:sub(self.scrollOffset + 1, self.scrollOffset + self.textLabel.w)
        end
    else
        -- NOT FOCUSED: Hand control back to the Label for standard marquee
        local baseText = #rawText == 0 and self.placeholder or rawText
        if self.masked and not self.isUnmasked and #rawText > 0 then
            baseText = (self.maskChar):rep(#rawText)
        end

        self.textLabel.fg = (#rawText == 0) and colours.lightGrey or self.fg
        self.textLabel.text = baseText
        -- Enable scrolling. Label:update() only moves if text > width.
        self.textLabel.scroll = true 
    end

    self.textLabel:render()

    -- Render cursor only when focused
    if self.focused and self.showCursor then
        local relativePos = self.cursorIndex - self.scrollOffset
        if relativePos >= 0 and relativePos < self.textLabel.w then
            m.setCursorPos(self.x + relativePos, self.y)
            m.setTextColor(self.fg)
            m.write(self.cursorChar)
        end
    end

    if self.toggleBtn then self.toggleBtn:render() end
end

function Input:update()
    -- Always update the label so its internal marquee timer runs
    self.textLabel:update()

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

    local localX = x - self.x
    self.cursorIndex = math.min(#self.text, self.scrollOffset + localX)

    self.cursorTimer = os.clock()
    self.showCursor = true
    self:render()
end

--- Captures focus and handles character/key events.
-- @tparam table event The ComputerCraft event table.
function Input:onType(event)
    local e = event[1]

    if e == "char" then
        if #self.text < self.maxLen then
            -- Insert character at cursorIndex
            local left = self.text:sub(1, self.cursorIndex)
            local right = self.text:sub(self.cursorIndex + 1)
            self.text = left .. event[2] .. right
            self.cursorIndex = self.cursorIndex + 1
        end

    elseif e == "paste" then
        local pText = event[2]
        if #self.text + #pText <= self.maxLen then
            local left = self.text:sub(1, self.cursorIndex)
            local right = self.text:sub(self.cursorIndex + 1)
            self.text = left .. pText .. right
            self.cursorIndex = self.cursorIndex + #pText
        end

    elseif e == "key" then
        local key = event[2]
        if key == keys.backspace then
            if self.cursorIndex > 0 then
                local left = self.text:sub(1, self.cursorIndex - 1)
                local right = self.text:sub(self.cursorIndex + 1)
                self.text = left .. right
                self.cursorIndex = self.cursorIndex - 1
            end
        elseif key == keys.delete then
            if self.cursorIndex < #self.text then
                local left = self.text:sub(1, self.cursorIndex)
                local right = self.text:sub(self.cursorIndex + 2)
                self.text = left .. right
            end
        elseif key == keys.left then
            self.cursorIndex = math.max(0, self.cursorIndex - 1)
        elseif key == keys.right then
            self.cursorIndex = math.min(#self.text, self.cursorIndex + 1)
        elseif key == keys.home then
            self.cursorIndex = 0
        elseif key == keys["end"] then
            self.cursorIndex = #self.text
        elseif key == keys.enter then
            self.focused = false
            GUI.focusedElement = nil
            self:render()
            if self.onSubmit then self.onSubmit(self.text) end
            return
        end
    end

    self.showCursor = true
    self.cursorTimer = os.clock()
    self:render()
end

GUI.register("Input", Input)