-- Project Metadata
project = 'Flux'
title = 'Flux Documentation'
description = 'A high-performance, fluid GUI library for CC:Tweaked'

-- Documentation Sources
file = { 
    'lib/gui/manager.lua', 
    'lib/gui/elements' 
}

dir = 'docs/api'           
format = 'markdown'        
ext = 'md'                 
use_markdown_titles = true 

-- Sidebar Customization for VitePress
kind_names = {
    topic = "Manuals",
    module = "Components"
}

-- ALIASES
-- Using the newline fix we discussed to ensure @tparam is recognized
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

-- Custom Tag Handling
custom_tags = {
    {'gui', hidden = true},
    {'internal', hidden = true}
}

-- Visual Tweaks
backtick_references = true -- Automatically links `ClassName` to its doc page
sort = true                -- Keeps the sidebar alphabetical