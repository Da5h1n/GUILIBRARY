--- Expandable selection menu for choosing from a list of options.
-- @module Dropdown
local GUI = ...


local Dropdown = setmetatable({}, GUI.UIElement)
Dropdown.__index = Dropdown

--- Creates a new Dropdown instance.
-- @tparam table opts Options include options (table), selected (index), and onSelect (callback).
function Dropdown:new(opts)
    local self = GUI.UIElement.new(self, opts)
    self.options = opts.options or {}
    self.selected = opts.selected or 1
    self.isOpen = false
    self.onSelect = opts.onSelect or function() end
    
    self.bg_open = opts.bg_open or colours.grey

    self.bg_list = opts.bg_list or colours.lightGrey
    self.fg_list = opts.fg_list or colours.black

    self.bg_sel = opts.bg_sel or colours.yellow
    self.fg_sel = opts.fg_sel or colours.black

    self.closedH = 1
    self.expandedH = #self.options + 1
    self.h = self.closedH

    self.scroll = opts.scroll or true
    self.scrollSpeed = opts.scrollSpeed or 0.3
    self.scrollDelay = opts.scrollDelay or 2.0

    self.headerLabel = GUI.newLabel({
        mon = self.mon, x = self.x, y = self.y, w = self.w, h = 1,
        text = "", align = "left", bg = self.bg, fg = self.fg,
        scroll = self.scroll, scrollSpeed = self.scrollSpeed, scrollDelay = self.scrollDelay
    })

    self.itemLabel = GUI.newLabel({
        mon = self.mon, x = self.x, y = self.y, w = self.w, h = 1,
        text = "", align = "left",
        scroll = self.scroll, scrollSpeed = self.scrollSpeed, scrollDelay = self.scrollDelay
    })

    return self
end

function Dropdown:render()
    local m = self.mon
    local arrow = self.isOpen and "v" or ">"
    local selectedText = tostring(self.options[self.selected] or "None")

    self.headerLabel.text = arrow .. " " .. selectedText
    self.headerLabel.bg = self.isOpen and self.bg_open or self.bg
    self.headerLabel:render()

    if self.isOpen then
        for i, option in ipairs(self.options) do
            self.itemLabel.y = self.y + i
            self.itemLabel.text = "  " .. tostring(option)

            if i == self.selected then
                self.itemLabel.bg, self.itemLabel.fg = self.bg_sel, self.fg_sel
            else
                self.itemLabel.bg, self.itemLabel.fg = self.bg_list, self.fg_list
            end

            self.itemLabel:render()
        end
    end
end

function Dropdown:click(x, y)
    if y == self.y then
        self.isOpen = not self.isOpen
        self.h = self.isOpen and self.expandedH or self.closedH
    elseif self.isOpen then
        local index = y - self.y
        if self.options[index] then
            self.selected = index
            self.isOpen = false
            self.h = self.closedH
            self.onSelect(self.options[index], index)
        end
    end
    if self.parentFrame then self.parentFrame:render(true) else self:render() end
end

GUI.register("Dropdown", Dropdown)