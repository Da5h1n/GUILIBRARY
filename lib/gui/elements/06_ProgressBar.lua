--- Visual bar for displaying percentage values with multiple orientations.
-- @module ProgressBar
local GUI = ...


local ProgressBar = setmetatable({}, GUI.UIElement)
ProgressBar.__index = ProgressBar

--- Creates a new ProgressBar instance.
-- @tparam table opts Options include value (0-100), barColour, direction (horizontal/vertical), and flipped.
function ProgressBar:new(opts)
    local self = GUI.UIElement.new(self, opts)

    self.value = math.floor(opts.value or 0)
    self.barColour = opts.barColour or colours.green
    self.showText = opts.showText ~= false
    self.direction = opts.direction or "horizontal"
    self.flipped = opts.flipped or false

    return self
end

function ProgressBar:render()
    local m = self.mon
    local displayVal = math.floor(self.value)

    m.setBackgroundColor(self.bg)
    for i = 0, self.h - 1 do
        m.setCursorPos(self.x, self.y + i)
        m.write((" "):rep(self.w))
    end

    m.setBackgroundColor(self.barColour)
    local fillW, fillH

    if self.direction == "horizontal" then
        fillW = math.floor((displayVal / 100) * self.w)
        if fillW > 0 then
            local startX = self.flipped and (self.x + self.w - fillW) or self.x
            for i = 0, self.h - 1 do
                m.setCursorPos(startX, self.y + i)
                m.write((" "):rep(fillW))
            end
        end
    else
        fillH = math.floor((displayVal / 100) * self.h)
        if fillH > 0 then
            local startY = self.flipped and self.y or (self.y + self.h - fillH)
            for i = 0, fillH - 1 do
                m.setCursorPos(self.x, startY + i)
                m.write((" "):rep(self.w))
            end
        end
    end

    if self.showText then
        local txt = displayVal .. "%"
        local tx = self.x + math.floor((self.w - #txt) / 2)
        local ty = self.y + math.floor(self.h / 2)

        for i = 1, #txt do
            local charX = tx + (i - 1)
            local char = txt:sub(i, i)
            local isFilled = false

            if self.direction == "horizontal" then
                local currentFillW = math.floor((displayVal / 100) * self.w)
                if self.flipped then
                    isFilled = charX >= (self.x + self.w - currentFillW)
                else
                    isFilled = charX < (self.x + currentFillW)
                end
            else
                local currentFillH = math.floor((displayVal / 100) * self.h)
                if self.flipped then
                    isFilled = (ty - self.y) < currentFillH
                else
                    isFilled = (ty - self.y) >= (self.h - currentFillH)
                end
            end

            if isFilled then
                m.setBackgroundColor(self.barColour)
                m.setTextColor(self.bg)
            else
                m.setBackgroundColor(self.bg)
                m.setTextColor(self.fg)
            end
            
            m.setCursorPos(charX, ty)
            m.write(char)
        end

    end
end

--- Updates the bar value and re-renders.
-- @tparam number val Percentage value (0-100).
function ProgressBar:setValue(val)
    local newValue = math.floor(math.max(0, math.min(100, val)))
    if newValue ~= self.value then
        self.value = newValue
        self:render()
    end
end

GUI.register("ProgressBar", ProgressBar)