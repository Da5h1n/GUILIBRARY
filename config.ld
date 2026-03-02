project = 'CC:Tweaked UI Framework'
title = 'UI Framework Documentation'
description = 'A modular GUI library for ComputerCraft'
full_description = 'This framework allows for modular UI elements using a Manager-Registry system.'

file = {
    'lib/gui/manager.lua',
    'lib/gui/elements'
}

dir = 'doc'
format = 'discount'
backtick_references = true
sort = true


custom_tags = {
    {'gui', hidden = true},
    {'internal', hidden = true}
}