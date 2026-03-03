--- Text display element with support for wrapping, complex alignment, scrolling, and truncation.
-- @module Label
local GUI = ...

local Label = setmetatable({}, GUI.UIElement)
Label.__index = Label

--- Creates a new Label instance.
-- @tparam table opts Options include text, align, vAlign, scroll, scrollSpeed, and scrollDelay.
function Label:new(opts)
    local self = GUI.UIElement.new(self, opts)
    self.text = tostring(opts.text or "")
    self.align = opts.align or "left" -- left, center, right, justify
    self.vAlign = opts.vAlign or "top" -- top, middle, bottom

    -- Scrolling properties
    self.scroll = opts.scroll or false
    self.scrollSpeed = opts.scrollSpeed or 0.3
    self.scrollDelay = opts.scrollDelay or 2.0

    -- Internal state for scrolling
    self.scrollOffset = 0
    self.scrollDir = 1
    self.lastScroll = os.clock()
    self.pauseUntil = 0

    return self
end

--- Internal helper to wrap text into lines based on width and alignment.
local function getWrappedLines(text, width, align)
    local lines = {}
    local words = {}

    for word in text:gmatch("%S+%s*") do
        table.insert(words, word)
    end

    local leading = text:match("^%s+")
    if leading and #words > 0 then
        words[1] = leading .. words[1]
    elseif leading and #words == 0 then
        table.insert(words, leading)
    end

    local currentLine = ""
    for _, word in ipairs(words) do
        -- If a single word is wider than the allowed width
        if #word > width then
            -- Push whatever was in the buffer first
            if #currentLine > 0 then table.insert(lines, currentLine) end
            
            -- Chop the long word into chunks that fit the width
            local remaining = word
            while #remaining > width do
                table.insert(lines, remaining:sub(1, width))
                remaining = remaining:sub(width + 1)
            end
            currentLine = remaining -- The leftover part starts the next line
        elseif #currentLine + #word <= width then
            currentLine = currentLine .. word
        else
            if #currentLine > 0 then table.insert(lines, currentLine) end
            currentLine = word
        end
    end
    if #currentLine > 0 then table.insert(lines, currentLine) end

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

--- Updates the label text and resets scrolling state.
-- @tparam string text The new string to display.
function Label:setText(text)
    self.text = tostring(text or "")
    self.scrollOffset = 0
    self:render()
end

--- Renders the label to the monitor.
function Label:render()
    local m = self.mon
    m.setBackgroundColor(self.bg)
    m.setTextColor(self.fg)

    -- Clear background area
    for i = 0, self.h - 1 do
        m.setCursorPos(self.x, self.y + i)
        m.write(string.rep(" ", self.w))
    end

    if self.scroll then
        -- MARQUEE MODE: Treat text as a single line and apply movement offset
        local startY = 0
        if self.vAlign == "middle" then startY = math.floor((self.h - 1) / 2)
        elseif self.vAlign == "bottom" then startY = self.h - 1 end
        
        m.setCursorPos(self.x, self.y + startY)
        local outText = self.text:sub(1 + math.floor(self.scrollOffset), self.w + math.floor(self.scrollOffset))
        m.write(outText)
    else
        local lines = getWrappedLines(self.text, self.w, self.align)

        local startY = 0
        if self.vAlign == "middle" then startY = math.floor((self.h - #lines) / 2)
        elseif self.vAlign == "bottom" then startY = self.h - #lines end
        startY = math.max(0, startY)

        for i = 1, #lines do
            if i > self.h then break end

            local outText = lines[i]

            if i == self.h and (#lines > self.h or #self.text > (self.w * self.h)) then
                if #outText >= self.w then
                    outText = outText:sub(1, self.w - 3) .. "..."
                elseif #outText > 0 then
                    outText = outText .. "..."

                    if #outText > self.w then outText = outText:sub(1, self.w-3) .. "..." end
                end
            end

            m.setCursorPos(self.x, self.y + startY + i - 1)
            m.write(outText)
        end
    end
end

--- Internal update loop for handling scrolling movement.
function Label:update()
    if not self.scroll then return end
    if #self.text <= self.w then return end
    if os.clock() < self.pauseUntil then return end

    if os.clock() - self.lastScroll > self.scrollSpeed then
        local maxOffset = #self.text - self.w

        self.scrollOffset = self.scrollOffset + self.scrollDir
        self.lastScroll = os.clock()

        -- Bounce back at the edges
        if self.scrollOffset >= maxOffset or self.scrollOffset <= 0 then
            self.scrollDir = -self.scrollDir
            self.pauseUntil = os.clock() + self.scrollDelay
        end

        self:render()
    end
end

GUI.register("Label", Label)