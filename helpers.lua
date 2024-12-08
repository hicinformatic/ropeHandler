i18nload = nil
entities_ropable = {}
vehicles_used = {}

-- Func to log messages in console
function logger(message, level)
    local color = Config.ColorsMsg.default[1]
    -- Check if the log level is "debug" and if the debug mode is enabled
    if level == "debug" and not Config.Debug then return end
    if level == nil then level = "info" end
    if Config.ColorsMsg[level] then color = Config.ColorsMsg[level][1] or Config.ColorsMsg.default[1] end
    if level ~= nil then
        print(string.format("%s (%s): %s%s", Config.PrefixMsg, level:upper(), message, Config.ColorsMsg.default[1]))
    else
        print(string.format("%s: %s%s", Config.PrefixMsg, message, Config.ColorsMsg.default[1]))
    end
end

-- Fun to log messages in chat
function chatmsg(message, level)
    -- Check if the log level is "debug" and if the debug mode is enabled
    if level == "debug" and not Config.Debug then return end
    -- Set the log level to "info" if it is not specified
    level = level or "info"
    TriggerEvent('chat:addMessage', {
        color = Config.ColorsMsg[level][2] or Config.ColorsMsg.default[2],
        multiline = true,
        args = {Config.PrefixMsg, message}
    })
end

function logmsg(message, level)
    chatmsg(message, level)
    logger(message, level)
end

-- Func to load the language file
function setLang(lang)
    if _G["lang" .. lang] then
        i18nload = _G["lang" .. lang]
    end
end

-- Func to translate messages
function i18n(message, ...)
    message = i18nload and i18nload[message] or message
    return string.format(message, ...)
end

-- Func to check if a string is in an array
function isStringInArray(array, str)
    for _, value in ipairs(array) do
        if value == str then
            return true
        end
    end
    return false
end

-- Func to get the index of a bone by name
function getBoneIndexByName(boneName)
    return Config.PedBones[boneName]
end

-- Func to get the entity type in string or number format
function getEntityTypeFormat(entity, format)
    format = format or "string"
    if IsEntityAPed(entity) then
        return format == "string" and "ped" or 1
    elseif IsEntityAVehicle(entity) then
        return format == "string" and "vehicle" or 2
    elseif IsEntityAnObject(entity) then
        return format == "string" and "object" or 3
    elseif IsEntityAMissionEntity(entity) then
        return format == "string" and "mission" or 4
    end
    return format == "string" and "coords" or 0
end

-- Func to disable controls
function disableControls(controls)
    for _, control in ipairs(controls) do
        DisableControlAction(0, control, true)
    end
end

-- Func to check if an entity is in a list of types
function isEntityInTypes(entity, types)
    for _, t in ipairs(types) do
        if getEntityTypeFormat(entity) == t then
            return true
        end
    end
    return false
end

-- Func to get keys from a table
function getKeys(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end

-- Func to get a config value
function getCfg(cfg, key, default)
    if cfg and cfg[key] then
        return cfg[key]
    end
    return default or nil
end

-- Func to get coords from bone ped or vehicle
function getCoordsEntity(entity, cfg)
    if cfg and cfg.bonePed then
        local boneIndex = GetPedBoneIndex(entity, getBoneIndexByName(cfg.bonePed))
        return GetWorldPositionOfEntityBone(entity, boneIndex)
    elseif cfg and cfg.boneVehicle then
        local boneIndex = GetEntityBoneIndexByName(entity, cfg.boneVehicle)
        return GetWorldPositionOfEntityBone(entity, boneIndex)
    end
    return GetEntityCoords(entity)
end

-- Func to set an entity as invincible
function setRopableEntity(entity)
    SetEntityInvincible(entity, true) -- Assurez-vous qu'il n'est pas invincible
    table.insert(entities_ropable, entity)
end

-- Func to unset an entity as invincible
function unsetRopableEntity(entity)
    SetEntityInvincible(entity, false) -- Désactiver l'invincibilité
end

-- Func to unset all entities as invincible
function unsetRopablePeds()
    for _, entity in ipairs(entities_ropable) do
        unsetRopableEntity(entity)
    end
end

-- Func to load a skin on a ped
function loadSkinPed(ped, skin)
    logmsg(i18n("Loading skin: %s", skin), "info")
    local model = GetHashKey(skin)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
end

-- Func to display the help message
function help()
    chatmsg(i18n("Usage: /ropehook [ropetype]"), "info")
    chatmsg(i18n("Available ropetypes:"), "info")
    for k, v in pairs(getKeys(Config.Commands)) do
        chatmsg(i18n("%d. %s", k, v), "info")
    end
end
