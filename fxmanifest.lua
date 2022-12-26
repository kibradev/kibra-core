fx_version "bodacious"

game "gta5"

author "Kibra#9999"

version "1.0.0"

description "Created by Kibra for Kibra Resources"

client_scripts {"shared.lua","framework/client.lua"}

server_scripts {"shared.lua","@mysql-async/lib/MySQL.lua", "framework/server.lua"}

shared_scripts {"config.lua", "shared.lua"}