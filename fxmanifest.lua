fx_version "cerulean"
games {"gta5"}

title "Rope Handler"
description "Rope Handler for FiveM"
author "Hicinformatic"
version "v1.0"

ui_page 'html/index.html'

client_scripts {
    -- Languages
    'i18n/fr.lua',
    -- Global
    'config.lua',
    'helpers.lua',
    'clients/aim.lua',
    'clients/animations.lua',
    'clients/items.lua',
    'clients/ropes.lua',
    'clients/shift.lua',
    'clients/ui.lua',
    'clients/weapons.lua',
    -- Ropes
    'ropes/bungeejumping/config.lua',
    'ropes/bungeejumping/init.lua',
    'ropes/grapplinghook/config.lua',
    'ropes/grapplinghook/init.lua',
    'ropes/justcause/config.lua',
    'ropes/justcause/init.lua',
    'ropes/prototype/config.lua',
    'ropes/prototype/init.lua',
    'ropes/spiderman/config.lua',
    'ropes/spiderman/init.lua',
    'ropes/venom/config.lua',
    'ropes/venom/init.lua',
    'ropes/whip/config.lua',
    'ropes/whip/init.lua',
    -- Tools
    'tools/measure/init.lua',
    'tools/measure/config.lua',
    'client.lua',
}

files {
    "html/index.html",
    "html/script.js",
    "html/style.css",
    'stream/*.yft',
    'stream/*.ytd',
    'stream/*.ymt',
    'stream/*.yft',
    'stream/*.meta'
}


data_file 'PED_METADATA_FILE' 'stream/IndianaJones1.meta'
data_file 'PED_METADATA_FILE' 'stream/SpiderMan2002.meta'
data_file 'PED_METADATA_FILE' 'stream/Venom.meta'
data_file 'PED_METADATA_FILE' 'stream/NathanDrake.meta'
data_file 'PED_METADATA_FILE' 'stream/alex_claws.meta'
