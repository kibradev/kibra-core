KIBRA = {}
KIBRA.ServerCallbacks = {}
KIBRA.Players = {}

RegisterNetEvent('KIBRA:Server:TriggerCallback', function(name, ...)
    local src = source
    KIBRA.TriggerCallback(name, src, function(...)
        TriggerClientEvent('KIBRA:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

KIBRA.CreateCallback = function(name, cb)
    KIBRA.ServerCallbacks[name] = cb
end

KIBRA.TriggerCallback = function(name, source, cb, ...)
    if not KIBRA.ServerCallbacks[name] then return end
    KIBRA.ServerCallbacks[name](source, cb, ...)
end

KIBRA.CreateCallback('Kibra:Core:Server:RequestPlayerName', function(source, cb)
    local Player = KIBRA.SourceFromPlayer(source)
    if Player then 
        cb(Player.GetPlayerName())
    else
        cb(false)
    end
end)

KIBRA.VIP = function(ThePlayer)
    local Self = {} 

    Self.AddInventoryItem = function(item, amount, slot, metadata)
        if Config.Framework == "ESX" then
            ThePlayer.addInventoryItem(item, amount)
        else
            ThePlayer.Functions.AddItem(item, amount, slot, metadata)
        end
    end

    Self.RemoveInventoryItem = function(item, amount, slot, metadata)
        if Config.Framework == "ESX" then
            ThePlayer.removeInventoryItem(item, amount)
        else
            ThePlayer.Functions.RemoveItem(item, amount, slot, metadata)
        end
    end

    Self.RemoveAccountMoney = function(account, amount)
        if Config.Framework == "ESX" then
            if account == "cash" then account = "money" end
            ThePlayer.removeAccountMoney(account, amount)
        else
            ThePlayer.Functions.RemoveMoney(account, amount)
        end
    end

    Self.AddAccountMoney = function(account, amount)
        if Config.Framework == "ESX" then
            if account == "cash" then account = "money" end
            ThePlayer.addAccountMoney(account, amount)
        else
            ThePlayer.Functions.AddMoney(account, amount)
        end
    end

    Self.GetSourceCoord = function()
        if Config.Framework == "ESX" then
            return ThePlayer.getCoords(true)
        else
            return QBCore.Functions.GetCoords(GetPlayerPed(ThePlayer.source))
        end
    end

    Self.GetPlayerName = function()
        if Config.Framework ==  "ESX" then
            return ThePlayer.getName()
        else
            return ThePlayer.PlayerData.charinfo.firstname.. ' '..ThePlayer.PlayerData.charinfo.lastname
        end
    end

    Self.GetPlayerMoney = function(type)
        if Config.Framework == "ESX" then
            if type == "cash" then type = "money" end
            if type == "bank" then
                return ThePlayer.getAccount('bank').money 
            else
                return ThePlayer.getAccount('money').money 
            end
        else
            return ThePlayer.PlayerData.money[type]
        end
    end

    Self.SetJob = function(job, grade)
        if Config.Framework == "ESX" then
            ThePlayer.setJob(job, grade)
        else
            ThePlayer.Functions.SetJob(job, grade)
        end
    end  

    Self.GetJob = function()
        if Config.Framework == "ESX" then
            return ThePlayer.job.name
        else
            return ThePlayer.PlayerData.job.name
        end
    end

    return KIBRA.Consubstantiate(Self, ThePlayer)
end

KIBRA.AllPlayers = function()
    if Config.Framework == "ESX" then
        return ESX.GetPlayers()
    else
        return QBCore.Functions.GetPlayers()
    end
end

KIBRA.CreateCallback('kibra:Core:GetJobs', function(source, cb, job)
    if Config.Framework == "ESX" then
        local MysqlMechanic = MySQL.Sync.fetchAll('SELECT * FROM users WHERE job = @job', {["@job"] = job})
        for k,v in pairs(MysqlMechanic) do
            tableV = {}
            table.insert(tableV, {identifier = v.identifier, name = v.firstname.. ' '..v.lastname, permission = v.job_grade})
        end
        cb(tableV)
    end
end)

KIBRA.GetIdentifierFromPlayer  = function(identifier)
    if Config.Framework == "ESX" then
        return ESX.GetPlayerFromIdentifier(identifier)
    else
        return QBCore.Functions.GetPlayerByCitizenId(identifier)
    end
end

KIBRA.CreateCallback('Kibra:Core:GetPlayerData', function(source, cb, data)
    local xPlayer = KIBRA.SourceFromPlayer(source)
    if not xPlayer then return end
    if data == "playerName" then
        cb(xPlayer.GetPlayerName())
    end
end)

KIBRA.SourceFromPlayer = function(source)
    local source = source
    if Config.Framework == "ESX" then 
        ThePlayer = ESX.GetPlayerFromId(source)
    elseif Config.Framework == "QBCore" then 
        ThePlayer = QBCore.Functions.GetPlayer(source)
        if not ThePlayer then return end
        ThePlayer.identifier = ThePlayer.PlayerData.citizenid
        ThePlayer.source = ThePlayer.PlayerData.source
        ThePlayer.phone = ThePlayer.PlayerData.charinfo.phone
    end
    ThePlayer = KIBRA.VIP(ThePlayer)
    return ThePlayer
end

KIBRA.DumpTable = function(table, nb)
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
			s = s .. '['..k..'] = ' .. KIBRA.DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

KIBRA.Consubstantiate = function(pData1, pData2)
    if not pData2 then return end
    for k, v in pairs(pData2) do
        if (type(v) == "table") and (type(pData1[k] or false) == "table") then
        KIBRA.Consubstantiate(pData1[k], pData2[k])
        else
            pData1[k] = v
        end
    end
    return pData1
end

KIBRA.CreateCallback('Kibra:Core:PlayerGetNameX', function(source, cb, id)
    id = tonumber(id)
    local xPlayer = KIBRA.SourceFromPlayer(id) 
    if xPlayer then
        cb(xPlayer.GetPlayerName())
    else
        cb(false)
    end
end)


RegisterNetEvent("Kibra:Core:PlayerInGame")
AddEventHandler('Kibra:Core:PlayerInGame', function()
    local source = source
    if KIBRA.Players[source] then 
        info = {}
        info = KIBRA.SourceFromPlayer(source)
        KIBRA.Players[source] = info
        PlayerName = info.GetPlayerName()
    end
    TriggerClientEvent('Kibra:Core:PlayerInGame', source, source)
end)