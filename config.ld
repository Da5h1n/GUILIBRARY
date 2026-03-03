project = 'Flux'
title = 'Flux Documentation'
description = 'A high-performance, fluid GUI library for CC:Tweaked'

file = { 
    'lib/gui/Flux.lua', 
    'lib/gui/elements' 
}
dir = 'docs/public/api'


format = 'html'

kind_names = {
    topic = "Manuals",
    module = "Components"
}

custom_tags = {
    {'gui', hidden = true},
    {'internal', hidden = true}
}

backtick_references = true
sort = true