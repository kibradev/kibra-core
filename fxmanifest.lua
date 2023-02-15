fx_version     "bodacious"
version        "1.1.0"
author         "Kibra"
game           "gta5"
description    "Creator by Kibra for Kibra Resources"
scriptname     "kibra-core"

client_scripts {
    "shared/main.lua",
    "shared/notify.lua",
    "common.lua",
    "client/main.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "shared/main.lua",
    "shared/notify.lua",
    "common.lua",
    "server/main.lua"
}

ui_page "web/index.html"

files {
    "web/index.html",
    "web/index.js",
    "web/style.css"
}