project = 'CC:Tweaked UI Framework'
title = 'NexusUI Documentation'
description = 'A modular GUI library for ComputerCraft'

file = {
    'lib/gui/manager.lua',
    'lib/gui/elements',
    'test2.lua'
}

-- This ensures your script sections show up in the navigation
kind_names = {
    script = "Examples",
    module = "Core Library"
}

dir = 'doc'
format = 'discount'
backtick_references = true
sort = true

custom_tags = {
    {'gui', hidden = true},
    {'internal', hidden = true}
}