current_usage = {
    throwed = {},
    mode = nil,
}
last_mode = nil


local function help()
    chatmsg(i18n("Usage: /ropehook [ropetype]"), "info")
    chatmsg(i18n("Available ropetypes:"), "info")
    for k, v in pairs(Config.Commands) do
        chatmsg(i18n("%d. %s", k, v), "info")
    end
end

local function PrepareUsage()
    current_usage = {
        throwed = {},
        mode = nil,
    }
end

local function CanStart(mode)
    logger(i18n("CanStart: %s", mode), "debug")
    logger(i18n("current_usage.mode: %s", current_usage.mode), "debug")
    if current_usage.mode ~= nil and current_usage.mode == mode then
        return false
    end
    return true
end

function IsThrowed()
    return #current_usage.throwed > 0
end

function RopeHandlerStart(mode)
    logger(i18n("Command /ropehandler called: %s", mode), "debug")
    if isStringInArray(Config.Ropes, mode) then
        logger(i18n("Rope type enabled: %s", mode), "debug")
        if CanStart(mode) then
            RopeHandlerStop()
            current_usage = {mode = mode or args[1]}
            last_mode = mode
            logger(i18n("Current usage mode: %s", current_usage.mode), "debug")
            _G[current_usage.mode .. "Init"]()
        else
            logger(i18n("Rope type already enabled: %s", mode), "debug")
        end
    elseif isStringInArray(Config.Commands, mode) then
        logger(i18n("Command launched: %s", mode), "debug")
        _G[mode .. "Init"]()
    else
        logger(i18n("Invalid ropetype: %s", mode), "debug")
        help()
        return
    end
end

function RopeHandlerStop()
    removeItems(items_loaded)
    removeRopes(ropes_loaded)
    items_loaded = {}
    items_named = {}
    ropes_loaded = {}
    ropes_named = {}
    PrepareUsage()
end

function RopeHandlerRestart()
    RopeHandlerStop()
    RopeHandlerStart(last_mode)
end

RegisterCommand('ropehandler', function(source, args, rawCommand)
    setLang(Config.DefaultLang)
    RopeHandlerStart(args[1] or "ui")
end, false)

Citizen.CreateThread(function()
     while true do
        Citizen.Wait(0)
        local isDead = IsEntityDead(PlayerPedId())
        if isDead then
            chatmsg(i18n("You are dead !"), "info")
            RopeHandlerStop()
            while IsEntityDead(playerPed) do
                Citizen.Wait(1000)
            end
        elseif current_usage.mode and isStringInArray(Config.Ropes, current_usage.mode) then
            -- Enable the rope mode
            _G[current_usage.mode .. "Thread"]()
        end
    end
end)

-- Supprimer l'objet lorsque le joueur quitte ou lorsque le script est arrêté
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        logmsg("Resource stopped", "debug")
        RopeHandlerStop()
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        logmsg("Resource started", "debug")
    end
end)

-- Optionnel : Supprimer l'objet lorsque le joueur quitte le serveur
AddEventHandler('playerDropped', function()
    logmsg("Resource stopped", "debug")
    RopeHandlerStop()
end)
