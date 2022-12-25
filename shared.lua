FRAMEWORK = nil 

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
else
    QBCore = exports['qb-core']:GetCoreObject()
end

exports("GetKibraCore", function()
    return KIBRA
end)

exports('GetFramework', function()
    return Config.Framework
end)

exports('GetEvents', function()
    local v = {Config.JobEvents[Config.Framework], Config.Events[Config.Framework]}
    return v
end)

exports('MySQLTableName', function()
    if Config.Framework == "ESX" then
        Memati = {"owned_vehicles", "vehicle"}
        return Memati
    else
        Memati = {"player_vehicles", "mods"}
        return Memati
    end
end)