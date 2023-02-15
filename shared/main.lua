Shared = {}

Shared.Framework = "QBCore" -- or "QBCore "

Shared.Notify = "default" -- or "okok" (okokNotify)

Shared.Events = {
    ["ESX"] = {
        "esx:playerLoaded",
        "esx:setJob",
        "esx:playerLogout"
    },

    ["QBCore"] = {
        "QBCore:Client:OnPlayerLoaded",
        "QBCore:Client:OnJobUpdate",
        "QBCore:Client:OnPlayerUnload"
    }
}