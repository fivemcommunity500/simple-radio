fx_version 'cerulean'
game 'gta5'

author 'Adri1216|FiveMCommunity'
description 'Sistema de radio para ESX-Legacy con ox_inventory'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'es_extended',
    'ox_inventory'
}

lua54 'yes'
