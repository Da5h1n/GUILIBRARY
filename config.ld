-- The name of your project (appears at the top of the sidebar)
project = 'CC:Tweaked UI Framework'

-- The title of the browser tab
title = 'NexusUI Documentation'

-- Brief descriptions for the home page
description = 'A modular GUI library for ComputerCraft'
full_description = 'A modular UI elements system using a Manager-Registry pattern for CC:Tweaked.'

-- MANUAL TOPICS
-- This tells LDoc to look for Markdown files to create "Custom Pages"
-- We use this for your Gallery/Example segments.
topics = {
    'examples.md'
}

-- SOURCE FILES
-- This tells LDoc which Lua files to scan for @module and @class tags.
file = {
    'lib/gui/manager.lua',
    'lib/gui/elements' -- This scans the entire folder
}

-- SIDEBAR CATEGORIES
-- This renames the default labels in the sidebar to be more professional.
kind_names = {
    topic = "Gallery",        -- Renames "Topics" to "Gallery"
    module = "API Reference"  -- Renames "Modules" to "API Reference"
}

-- OUTPUT SETTINGS
dir = 'doc'               -- The folder where the website is generated
format = 'discount'       -- Enables Markdown support in your comments
backtick_references = true -- Allows `Manager` to become a clickable link
sort = true                -- Sorts functions alphabetically

-- CUSTOM TAGS
-- This handles the @internal and @gui tags we added to your code
custom_tags = {
    {'gui', hidden = true},
    {'internal', hidden = true}
}