fx_version "cerulean"
games {"gta5"}

title "Rope Handler"
description "Rope Handler for FiveM"
author "Hicinformatic"
version "v1.0"

ui_page 'html/index.html'

files {
    "html/index.html",
    "html/script.js",
    "html/style.css",
    "html/i18n/fr.js",
}

client_scripts {
    'i18n/fr.lua',
    'config.lua',
    'helpers.lua',
    'clients/aim.lua',
    'clients/animations.lua',
    'clients/items.lua',
    'clients/ropes.lua',
    'clients/shift.lua',
    'clients/ui.lua',
    -- Ropes
    'ropes/grapplinghook/config.lua',
    'ropes/grapplinghook/init.lua',
    'ropes/spiderman/config.lua',
    'ropes/spiderman/init.lua',
    'client.lua',
}
