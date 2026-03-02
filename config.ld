project = 'CC:Tweaked UI Framework'
title = 'UI Framework Documentation'
description = 'A modular GUI library for ComputerCraft'
full_description = 'This framework allows for modular UI elements using a Manager-Registry system.'

-- Look for files in the current directory and subdirectories
file = {
    'lib/gui/manager.lua',
    'lib/gui/elements'
}

-- Output directory
dir = 'doc'

-- Formatting
format = 'discount' -- Enables markdown support in your comments
backtick_references = true
sort = true

-- Handle the "local GUI = ..." pattern
-- This tells LDoc that 'GUI' inside files refers to the 'Manager' class
custom_tags = {
    {'gui', hidden = true}
}