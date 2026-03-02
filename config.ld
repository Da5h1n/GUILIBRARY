-- Project Metadata
project = 'CC:Tweaked UI Framework'
title = 'NexusUI Documentation'
description = 'A modular GUI library for ComputerCraft'
full_description = 'A modular UI elements system using a Manager-Registry pattern for CC:Tweaked.'

-- Documentation Sources
-- 1. Topics: These are manual Markdown files (Your segmented Gallery)
topics = {
    'examples.md'
}

-- 2. File: These are the Lua source files to be scanned for API documentation
file = {
    'lib/gui/manager.lua',
    'lib/gui/elements'
}

-- Sidebar Customization
-- Renames the default categories to be more user-friendly
kind_names = {
    topic = "Gallery",
    module = "API Reference"
}

-- Output Settings
dir = 'doc'                -- The output directory for generated HTML
format = 'discount'        -- Enables Markdown parsing in comments
backtick_references = true -- Automatically links `Names` to their documentation
sort = true                -- Sorts functions and modules alphabetically

-- Custom Tag Handling
-- These hide the @gui and @internal tags from the final output while still processing them
custom_tags = {
    {'gui', hidden = true},
    {'internal', hidden = true}
}

-- Visual Tweaks
no_return_or_parms = false -- Ensure parameters and return values are shown
no_summary = false         -- Show the summary table at the top of pages