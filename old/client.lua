isRopeTypeEnable = nil
is_rope_throwed_item = nil
is_rope_throwed = false
entity_attached = nil
entity_type = nil

local function help()
    chatmsg("Usage: /ropehook [ropetype]", "info")
    chatmsg("Available ropetypes:", "info")
    for k, v in pairs(Config.RopeTypes) do
        chatmsg("-- " .. v .. " --", "info")
    end
end

function RopeHandlerStop()
    removeItems()
    removeRopes()
    logger("RopeHandler stopped", "info")
    isRopeTypeEnable = nil
    is_rope_throwed_item = nil
    is_rope_throwed = false
    entity_attached = nil
    entity_type = nil
end

function RopeHandlerRestart()
    local SaveRopeType = isRopeTypeEnable
    RopeHandlerStop()
    isRopeTypeEnable = SaveRopeType
    _G[isRopeTypeEnable .. "Start"]()
end

RegisterCommand('ropehandler', function(source, args, rawCommand)
    logger("Command /ropehook called: " .. args[1], "info")
    isRopeTypeEnable = args[1]
    if isStringInArray(Config.RopeTypes, isRopeTypeEnable) then
        logger("Rope type enabled: " .. isRopeTypeEnable, "info")
    else
        logger("Invalid ropetype: " .. isRopeTypeEnable, "error")
        help()
        return
    end

    _G[isRopeTypeEnable .. "Start"]()
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isStringInArray(Config.RopeTypes, isRopeTypeEnable) then
            TriggerEvent('disableWeaponWheel', true)
            _G[isRopeTypeEnable .. "Thread"]()
            TriggerEvent('disableWeaponWheel', false)
        end
    end
end)
