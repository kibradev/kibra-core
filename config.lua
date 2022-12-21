Config = {}

Config.Framework = "ESX" -- or QBCore

Config.DrawMarkerRGBAColor = {2,47,255,0.8}

Config.Events = {
    ["ESX"] = "esx:playerLoaded",
    ["QBCore"] = "QBCore:Client:OnPlayerLoaded"
}

Config.JobEvents = {
    ["ESX"] = "esx:setJob",
    ["QBCore"] = "QBCore:Client:OnJobUptade"
}