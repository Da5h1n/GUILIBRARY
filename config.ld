-- Project Metadata
project = 'Flux'
title = 'Flux Documentation'
description = 'A high-performance, fluid GUI library for CC:Tweaked'

-- Sources
file = { 
    'lib/gui/Flux.lua', 
    'lib/gui/elements' 
}
dir = 'docs/api'

ext = 'html'
format = 'html' 

kind_names = {
    topic = "Manuals",
    module = "Components"
}

-- Custom Tag Handling
custom_tags = {
    {'gui', hidden = true},
    {'internal', hidden = true}
}

backtick_references = true
sort = true