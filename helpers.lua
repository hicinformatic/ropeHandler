i18nload = nil

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
    else
        logger("Language not found: " .. lang, "error")
    end
end

-- Func to translate messages
function i18n(message, ...)
    message = i18nload[message] or message
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
    logger("getBoneIndexByName: " .. boneName, "debug")
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

function disableControls(controls)
    for _, control in ipairs(controls) do
        DisableControlAction(0, control, true)
    end
end

function isEntityInTypes(entity, types)
    for _, t in ipairs(types) do
        if getEntityTypeFormat(entity) == t then
            return true
        end
    end
    return false
end

function getCfg(config, key, default)
    if config and config[key] then
        return config[key]
    end
    return default or nil
end

function getCoordsEntity(entity, config)
    if config and config.bonePed then
        local boneIndex = GetPedBoneIndex(entity, getBoneIndexByName(config.bonePed))
        return GetWorldPositionOfEntityBone(entity, boneIndex)
    elseif config and config.boneVehicle then
        local boneIndex = GetEntityBoneIndexByName(entity, config.boneVehicle)
        return GetWorldPositionOfEntityBone(entity, boneIndex)
    end
    return GetEntityCoords(entity)
end
