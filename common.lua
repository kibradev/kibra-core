Framework = nil 

if Shared.Framework == "ESX" then
    Framework = exports["es_extended"]:getSharedObject()
else
    Framework = exports["qb-core"]:GetCoreObject()
end

exports('GetCore', function()
    return KIBRA
end)

exports('GetFramework', function()
    return Shared.Framework
end)
