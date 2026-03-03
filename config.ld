project = 'NexusUI'
title = 'NexusUI Documentation'
description = 'A modular GUI library for CC:Tweaked'

file = { 'lib/gui/manager.lua', 'lib/gui/elements' }
dir = 'doc'
format = 'discount'

-- Customization
style = 'doc/style.css'      -- Path to your custom CSS
template = 'doc/templates'   -- Path to your custom HTML templates folder

-- ALIASES: This is how we make annotations carry through.
-- Use @common_opts in any file to insert the standard UI parameters.
alias('common_opts', [[
@tparam table opts Options table:
@tparam[opt] string opts.id Unique ID
@tparam[opt=1] number opts.x X position
@tparam[opt=1] number opts.y Y position
@tparam[opt] number opts.w Width
@tparam[opt] number opts.h Height
@tparam[opt] number opts.bg Background Color
@tparam[opt] number opts.fg Foreground Color
@tparam[opt] table opts.mon Target monitor
]])

custom_tags = {
    {'gui', hidden = true},
    {'internal', hidden = true}
}