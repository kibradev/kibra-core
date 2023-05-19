fx_version     "bodacious"
version        "1.1.1"
author         "Kibra"
game           "gta5"
description    "Creator by Kibra for Kibra Resources"
scriptname     "kibra-core"

client_scripts {
    "config.lua",
    "common.lua",
    "client.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "common.lua",
    "server.lua"
}

ui_page "web/index.html"

files {
    "web/index.html",
    "web/index.js",
    "web/style.css"
}