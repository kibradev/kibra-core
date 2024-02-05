Framework = nil 

if GetResourceState('es_extended') ~= 'missing' then
    Shared.Framework = 'ESX' 
else
    Shared.Framework = 'QBCore'
end

if not Shared.OldFramework then
    if Shared.Framework == "ESX" then
        Framework = exports["es_extended"]:getSharedObject()
    else
        Framework = exports["qb-core"]:GetCoreObject()
    end 
end

exports('GetFramework', function()
    return Shared.Framework
end)

exports('GetCore', function()
    return KIBRA
end)


exports('GetOld', function()
    return Shared.OldFramework
end)
