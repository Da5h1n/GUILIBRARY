project = 'Flux'
title = 'Flux Documentation'
description = 'A high-performance, fluid GUI library for CC:Tweaked'

file = { 'lib/gui/Flux.lua', 'lib/gui/elements' }
dir = 'docs/api'
-- We use 'discount' to parse your comments, but NOT 'format = markdown'
format = 'discount' 
ext = 'md' 
-- This ensures LDoc uses its multi-file engine but writes .md files
use_markdown_titles = true 

alias('common_opts', [[
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