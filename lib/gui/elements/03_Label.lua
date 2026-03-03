--- Text display element with support for wrapping and complex alignment.
-- @module Label
local GUI = ...


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

    -- 1. Capture words and their following spaces
    for word in text:gmatch("%S+%s*") do
        table.insert(words, word)
    end

    -- Preserve leading spaces
    local leading = text:match("^%s+")
    if leading and #words > 0 then
        words[1] = leading .. words[1]
    elseif leading and #words == 0 then
        table.insert(words, leading)
    end

    -- 2. Wrap words into lines (stored as strings)
    local currentLine = ""
    for _, word in ipairs(words) do
        if #currentLine + #word <= width then
            currentLine = currentLine .. word
        else
            if #currentLine > 0 then table.insert(lines, currentLine) end
            currentLine = word
        end
    end
    table.insert(lines, currentLine)
    
    local processedLines = {}
    for i, lineStr in ipairs(lines) do
        local trimmed = lineStr:gsub("%s+$", "")

        if align == "justify" and i < #lines then
            local justifyWords = {}
            for w in lineStr:gmatch("%S+") do table.insert(justifyWords, w) end

            if #justifyWords > 1 then
                local totalChars = 0
                for _, w in ipairs(justifyWords) do totalChars = totalChars + #w end
                
                local spacesNeeded = width - totalChars
                local gaps = #justifyWords - 1
                local spacePerGap = math.floor(spacesNeeded / gaps)
                local extraSpaces = spacesNeeded % gaps

                local justified = ""
                for j, w in ipairs(justifyWords) do
                    justified = justified .. w
                    if j < #justifyWords then
                        local s = spacePerGap + (j <= extraSpaces and 1 or 0)
                        justified = justified .. string.rep(" ", s)
                    end
                end
                table.insert(processedLines, justified)
            else
                table.insert(processedLines, lineStr)
            end
        elseif align == "center" then
            local pad = math.floor((width - #trimmed) / 2)
            table.insert(processedLines, string.rep(" ", pad) .. trimmed)
        elseif align == "right" then
            local pad = width - #trimmed
            table.insert(processedLines, string.rep(" ", pad) .. trimmed)
        else
            table.insert(processedLines, lineStr)
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