current_usage = nil
rope_mode = nil

is_rope_throwed_item = nil
is_rope_throwed = false
entity_attached = nil
entity_type = nil

local function help()
    message(i18n("Usage: /ropehook [ropetype]"), "info")
    message(i18n("Available ropetypes:"), "info")
    for k, v in pairs(Config.Commands) do
        message(i18n("%d. %s", k, v), "info")
    end
end

function RopeHandlerStop()
    removeItems(items_loaded)
    items_loaded = {}
    removeRopes(ropes_loaded)
    ropes_loaded = {}
    current_usage = nil
    rope_mode = nil
end

function ropeHandlerStart(mode)
    logger(i18n("Command /ropehandler called: %s", mode), "debug")
    if isStringInArray(Config.Commands, mode) then
        logger(i18n("Rope type enabled: %s", mode), "debug")
        current_usage = {mode = mode or args[1]}
    else
        logger(i18n("Invalid ropetype: %s", mode), "debug")
        help()
        return
    end
    _G[current_usage.mode .. "Init"]()
end

function RopeHandlerRestart()
    local current_save = current_usage
    RopeHandlerStop()
    current_usage = current_save
    ropeHandlerStart()
end

RegisterCommand('ropehandler', function(source, args, rawCommand)
    setLang(Config.DefaultLang)
    ropeHandlerStart(args[1] or "ui")
end, false)

Citizen.CreateThread(function()
     while true do
        Citizen.Wait(0)
        if rope_mode and isStringInArray(Config.Commands, rope_mode) then
            TriggerEvent('disableWeaponWheel', true)
            _G[rope_mode .. "Thread"]()
            TriggerEvent('disableWeaponWheel', false)
        end
    end
end)
