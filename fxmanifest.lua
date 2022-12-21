fx_version "bodacious"

game "gta5"

author "Kibra#9999"

version "1.0.0"

description "Created by Kibra for Kibra Resources"

client_script "framework/client.lua"

server_scripts {"@mysql-async/lib/MySQL.lua", "framework/server.lua"}

shared_scripts {"config.lua", "shared.lua"}