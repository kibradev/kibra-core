KIBRA = {}
KIBRA.Natives = {}
KIBRA.Players = {}
KIBRA.ServerCallbacks = {}

if Shared.OldFramework then
    if Shared.Framework == "ESX" then
        Framework = nil
        TriggerEvent('esx:getSharedObject', function(obj) Framework = obj end)
    else
        Framework = nil
        TriggerEvent('QBCore:GetObject', function(obj) Framework = obj end)
    end
end

function KIBRA.Natives.CreateCallback(name, cb)
    KIBRA.ServerCallbacks[name] = cb
end

function KIBRA.Natives.GetOld()
    return Shared.OldFramework
end

function KIBRA.Natives.TriggerCallback(name, requestId, source, Invoke, cb, ...)
    local callback = KIBRA.ServerCallbacks[name]
    if callback then
        callback(source, cb, ...)
    else
        print(('[^1ERROR^7] Server callback ^5"%s"^0 does not exist. Please Check ^5%s^7 for Errors!'):format(name, Invoke))
    end
end

RegisterNetEvent('KIBRA:Server:TriggerCallback', function(name, ...)
    local src = source
    KIBRA.Natives.TriggerCallback(name, src, function(...)
        TriggerClientEvent('KIBRA:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

RegisterServerEvent('kibra:triggerServerCallback')
AddEventHandler('kibra:triggerServerCallback', function(name, requestId, Invoke, ...)
    local source = source
    KIBRA.Natives.TriggerCallback(name, requestId, source, Invoke, function(...)
        TriggerClientEvent('kibra:serverCallback', source, requestId, Invoke, ...)
    end, ...)
end)


function KIBRA.Natives.GetFramework()
    return Shared.Framework
end

function KIBRA.Natives.SourceFromPlayer(source)
    local src = source
    if Shared.Framework == "ESX" then
        vPlayer = Framework.GetPlayerFromId(src)
    else
        vPlayer = Framework.Functions.GetPlayer(src)
        if not vPlayer then return end 
        vPlayer.identifier = vPlayer.PlayerData.citizenid
        vPlayer.license = vPlayer.PlayerData.license
        vPlayer.source = vPlayer.PlayerData.source
        vPlayer.job = vPlayer.PlayerData.job
        vPlayer.job.name = vPlayer.PlayerData.job.name
        vPlayer.job.grade_name = vPlayer.job.grade.name
    end
    vPlayer = KIBRA.Natives.TableUpdate(vPlayer)
    return vPlayer
end

KIBRA.Natives.MergeTable = function(t1, t2)
    if not t2 then return end
    for k, v in pairs(t2) do
        if (type(v) == "table") and (type(t1[k] or false) == "table") then
            KIBRA.Natives.MergeTable(t1[k], t2[k])
        else
            t1[k] = v
        end
    end
    return t1
end

function KIBRA.Natives.AllPlayers()
    if Shared.Framework == "ESX" then
        return Framework.GetPlayers()
    else
        return Framework.Functions.GetPlayers()
    end
end

function KIBRA.Natives.TableUpdate(vPlayer)
    local xPlayer = {}
    local framework = Shared.Framework

    xPlayer.getPlayerMoney = function()
        local theMoney = {}
        if framework == "ESX" then
            theMoney.cash = vPlayer.getAccount('money').money
            theMoney.bank = vPlayer.getAccount('bank').money 
        else
            theMoney.cash = vPlayer.PlayerData.money["cash"]
            theMoney.bank = vPlayer.PlayerData.money["bank"]
        end
        return theMoney
    end

    xPlayer.getPlayerCoord = function()
        local ped
        if framework == "ESX" then
            return vPlayer.getCoords(true) 
        else
            ped = GetPlayerPed(vPlayer.source)
            return Framework.Functions.GetCoords(ped)
        end
    end

    xPlayer.giveAccountMoney = function(account, money)
        if framework == "ESX" then
            if account == "cash" then account = "money" end
            vPlayer.addAccountMoney(account, money)
        else
            vPlayer.Functions.AddMoney(account, money)
        end
    end

    xPlayer.removePlayerMoney = function(account, money)
        if framework == "ESX" then
            if account == "cash" then account = "money" end 
            vPlayer.removeAccountMoney(account, money)
        else
            vPlayer.Functions.RemoveMoney(account, money)
        end
    end

    xPlayer.addItem = function(item, amount, slot, metadata)
        if framework == "ESX" then
            vPlayer.addInventoryItem(item, amount, metadata)
        else
            vPlayer.Functions.AddItem(item, amount, slot, metadata)
        end
    end

    xPlayer.getPlayerName = function()
        local name
        if framework == "ESX" then
            name = vPlayer.getName()
        else
            name = vPlayer.PlayerData.charinfo.firstname..' '..vPlayer.PlayerData.charinfo.lastname
        end
        return name
    end

    xPlayer.setPlayerJob = function(job, grade)
        if framework == "ESX" then
            vPlayer.setJob(job, grade)
        else
            vPlayer.Functions.SetJob(job, grade)
        end
    end
    

    xPlayer.getPlayerJob = function(job, grade)
        local theJob = {}
        if Shared.Framework == "ESX" then
            theJob.job = vPlayer.job
            theJob.job.name = vPlayer.job.name
        else
            theJob.job = vPlayer.PlayerData.job
            theJob.job.name = vPlayer.PlayerData.job.name
        end
        return theJob
    end

    return KIBRA.Natives.MergeTable(xPlayer, vPlayer)
end

KIBRA.Natives.SetJobSQL = function(job, grade, identifier)
    if Shared.Framework == "ESX" then
        MySQL.Async.execute('UPDATE `users` SET `job` = @job, `job_grade` = @grade WHERE `identifier` = @id', {
            ["@id"] = identifier,
            ["@job"] = job,
            ["@grade"] = grade
        })
    else
        local getData = MySQL.Sync.fetchAll('SELECT * FROM players WHERE citizenid = @id', {["@id"] = identifier})
        local data = json.decode(getData[1].job)
        data.name = job
        data.grade.level = grade 
        MySQL.Async.execute('UPDATE players SET job = @job WHERE citizenid = @id', {["@id"] = identifier, ["@job"] = json.encode(data)})
    end
end

function KIBRA.Natives.HasPermission(source, perm) 
    local vPlayer = KIBRA.Natives.SourceFromPlayer(source)
    local framework = Shared.Framework
    local check = false 
    if framework == "QBCore" then
        if perm == "admin" then perm = "god" end
        if vPlayer.Functions.HasPermission(perm) then
            check = true
        end
    else
        if vPlayer.getGroup() == perm then
            check = true
        end
    end
    return check
end

function KIBRA.Natives.GetPlayerFromIdentifier(identifier)
    if Shared.Framework == "ESX" then
        local source = Framework.GetPlayerFromIdentifier(identifier)
        if source then
            return source
        end
    else
        return Framework.Functions.GetPlayerByCitizenId(identifier).PlayerData.source
    end
end

KIBRA.Natives.DumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end
	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end
		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. KIBRA.Natives.DumpTable(v, nb + 1) .. ',\n'
		end
		for i = 1, nb, 1 do
			s = s .. "    "
		end
		return s .. '}'
	else
		return tostring(table)
	end
end
