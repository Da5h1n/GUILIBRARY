--- Text display element with support for wrapping and complex alignment.
-- @module Label
local GUI = ...

--- @class Label
local Label = setmetatable({}, GUI.UIElement)
Label.__index = Label

--- Creates a new Label instance.
-- @tparam table opts Options include align (left, center, right, justify) and vAlign (top, middle, bottom).
function Label:new(opts)
    local self = GUI.UIElement.new(self, opts)
    self.text = opts.text or ""
    self.align = opts.align or "left" -- left, center, right, justify
    self.vAlign = opts.vAlign or "top" -- top, middle, bottom
    return self
end

--- Updates the label text and re-renders.
-- @tparam string text The new string to display.
function Label:setText(text)
    self.text = tostring(text or "")
    self:render()
end

local function getWrappedLines(text, width, align)
    local lines = {}
    local words = {}
    for word in text:gmatch("%S+") do table.insert(words, word) end

    local currentLine = {}
    local currentLen = 0

    for _, word in ipairs(words) do
        if currentLen + #word + #currentLine <= width then
            table.insert(currentLine, word)
            currentLen = currentLen + #word
        else
            table.insert(lines, currentLine)
            currentLine = {word}
            currentLen = #word
        end
    end
    table.insert(lines, currentLine)

    local processedLines = {}
    for i, lineWords in ipairs(lines) do
        local lineStr = table.concat(lineWords, " ")

        if align == "justify" and i < #lines and #lineWords > 1 then
            local totalChars = 0
            for _, w in ipairs(lineWords) do totalChars = totalChars + #w end
            local spacesNeeded = width - totalChars
            local gaps = #lineWords - 1
            local spacePerGap = math.floor(spacesNeeded / gaps)
            local extraSpaces = spacesNeeded % gaps

            local justified = ""
            for j, w in ipairs(lineWords) do
                justified = justified .. w
                if j < #lineWords then
                    local s = spacePerGap + (j <= extraSpaces and 1 or 0)
                    justified = justified .. string.rep(" ", s)
                end
            end
            table.insert(processedLines, justified)
        else
            if align == "center" then
                local pad = math.floor((width - #lineStr) / 2)
                table.insert(processedLines, string.rep(" ", pad) .. lineStr)
            elseif align == "right" then
                local pad = width - #lineStr
                table.insert(processedLines, string.rep(" ", pad) .. lineStr)
            else
                table.insert(processedLines, lineStr)
            end
        end
    end
    return processedLines
end

function Label:render()
    local m = self.mon
    m.setBackgroundColor(self.bg)
    m.setTextColor(self.fg)

    for i = 0, self.h - 1 do
        m.setCursorPos(self.x, self.y + i)
        m.write(string.rep(" ", self.w))
    end

    local lines = getWrappedLines(self.text, self.w, self.align)

    local startY = 0
    if self.vAlign == "middle" then
        startY = math.floor((self.h - #lines) / 2)
    elseif self.vAlign == "bottom" then
        startY = self.h - #lines
    end
    startY = math.max(0, startY)

    for i, lineContent in ipairs(lines) do
        if i + startY > self.h then break end
        m.setCursorPos(self.x, self.y + startY + i - 1)
        m.write(lineContent:sub(1, self.w))
    end
end

GUI.register("Label", Label)