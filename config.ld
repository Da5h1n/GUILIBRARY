project = 'Flux'
title = 'Flux Documentation'
description = 'A high-performance, fluid GUI library for CC:Tweaked'

file = { 'lib/gui/Flux.lua', 'lib/gui/elements' }
dir = 'docs/api'

-- DO NOT USE 'markdown' or 'discount' here if the error persists.
-- 'plain' or 'html' (default) is safer for multi-file output.
format = 'plain' 
ext = 'md'

-- We handle the naming of sections via kind_names
kind_names = {
    topic = "Manuals",
    module = "Components"
}

-- ALIAS FIX: Rename to avoid the underscore which is causing the 'unknown tag'
alias('common', [[
@tparam table opts Options table:
@tparam[opt] string opts.id Unique ID
@tparam[opt=1] number opts.x X position
@tparam[opt=1] number opts.y Y position
@tparam[opt] number opts.w Width
@tparam[opt] number opts.h Height
@tparam[opt] number opts.bg Background Color
@tparam[opt] number opts.fg Foreground Color
@tparam[opt] table opts.mon Target monitor]])

custom_tags = {
    {'gui', hidden = true},
    {'internal', hidden = true}
}

backtick_references = true
sort = true