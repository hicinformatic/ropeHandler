current_usage = nil
base_skin = nil
load_skin = nil
is_dead = nil
is_dead_stop = false
is_unique_thrown = nil
is_multiple_thrown = {}
invicible = false

-- Func to start the rope
function RopeHandlerStart(mode, skin, invincible)
    logger(i18n("Command /ropehandler called: %s", mode), "debug")
    if isStringInArray(getKeys(Config.Ropes), mode) or isStringInArray(getKeys(Config.Tools), mode) then
        if current_usage then
            RopeHandlerStop()
        end
        current_usage = mode
        if skin then
            load_skin = true
            loadSkinPed(ped, skin)
        end
        load_skin = skin or false
        SetEntityInvincible(PlayerPedId(), invincible or false)
        StartInitOrThread(current_usage, "Init")
    elseif isStringInArray(getKeys(Config.Commands), mode) then
        StartInitOrThread(mode, "Init")
    else
        logger(i18n("Invalid ropetype: %s", mode), "debug")
        help()
    end
end

-- Func to stop the rope
function RopeHandlerStop(cfg)
    logger(i18n("Rope stopping"), "debug")
    removeRopes(ropes_loaded)
    removeItems(items_loaded)
    removeWeapons(weapons_loaded)
    unsetRopablePeds(peds_used)
    items_loaded = {}
    items_named = {}
    ropes_loaded = {}
    ropes_named = {}
    current_usage = nil
    is_unique_thrown = nil
    is_multiple_thrown = {}
    logger(i18n("Rope stopped"), "debug")
end

RegisterCommand('ropehandler', function(source, args, rawCommand)
    if not base_skin then
        base_skin = GetEntityArchetypeName(PlayerPedId())
    end
    setLang(Config.DefaultLang)
    RopeHandlerStart(args[1] or "ui")
end, false)

function StartInitOrThread(mode, method)
    if _G[mode .. method] then
        _G[mode .. method]()
    end
end

Citizen.CreateThread(function()
     while true do
        Citizen.Wait(0)
        is_dead = IsEntityDead(PlayerPedId())
        if is_dead and not is_dead_stop then
            chatmsg(i18n("You are dead !"), "info")
            RopeHandlerStop()
            Citizen.Wait(1000)
            is_dead_stop = true
        elseif current_usage and isStringInArray(getKeys(Config.Ropes), current_usage) then
            is_dead_stop = false
            StartInitOrThread(current_usage, "Thread")
        elseif current_usage and isStringInArray(getKeys(Config.Tools), current_usage) then
            is_dead_stop = false
            StartInitOrThread(current_usage, "Thread")
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
    logmsg("Player dropped", "debug")
    RopeHandlerStop()
end)
