fx_version 'cerulean'
games { 'gta5' }
author 'Zaps6000'
version '1.5'
lua54 'yes'
client_scripts {
'main.lua',
}

server_scripts {
'server.lua',
}

shared_script {
        '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'config.lua'
}

