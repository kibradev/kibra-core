FRAMEWORK = nil 

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
else
    QBCore = exports['qb-core']:GetCoreObject()
end

exports("GetKibraCore", function()
    return KIBRA
end)

exports('GetSetJobEvent', function()
    return Config.JobEvents[Config.Framework]
end)

exports('MySQLTableName', function()
    if Config.Framework == "ESX" then
        Memati = {"owned_vehicles", "vehicles"}
        return Memati
    else
        Memati = {"player_vehicles", "mods"}
        return Memati
    end
end)