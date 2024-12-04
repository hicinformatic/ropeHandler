items_loaded = {}
items_named = {}

function getModel(model)
    RequestModel(model)  -- Charger le modèle
    while not HasModelLoaded(model) do
        Wait(500)  -- Attendre que le modèle soit chargé
    end
    return GetHashKey(model)
end

function SpawnItem(item, config)
    local entityToPos = (config and config.entityToPos) or PlayerPedId()
    local initPos

    if config and config.coords then
        initPos = config.coords
    elseif config and config.bonePos then
        local boneIndex = GetPedBoneIndex(entityToPos, getBoneIndexByName(config.bonePos))
        initPos = GetWorldPositionOfEntityBone(entityToPos, boneIndex)
    else
        initPos = GetEntityCoords(entityToPos)
    end

    if config and config.entityOffset then initPos = initPos + config.entityOffset end

    local modelhash = getModel(item)
    local entity = CreateObject(
        modelhash,
        (config and config.axis) or initPos,
        (config and config.isNetwork) or true,
        (config and config.isPhysical) or true,
        (config and config.doorFlag) or false
    )

    if config and config.entityFixed then SetEntityCollision(entity, false, false) end
    if config and config.entityRotation then SetEntityRotation(entity, config.entityRotation, 2, true) end
    if config and config.noCollision then SetEntityCompletelyDisableCollision(entity, false, true) end
    if config and config.invisible then SetEntityVisible(entity, false, false) end
    if config and config.itemname then items_named[config.itemname] = entity end

    SetModelAsNoLongerNeeded(modelhash)
    table.insert(items_loaded, entity)
    return entity
end

function AttachItem(entity, to, config)
    local boneIndex
    if config and config.bone then
        boneIndex = GetPedBoneIndex(to, getBoneIndexByName(config.bone))
    end

    AttachEntityToEntity(
        entity,
        to,
        boneIndex,
        (config and config.offset) or vector3(0.0, 0.0, 0.0),
        (config and config.rotation) or vector3(0.0, 0.0, 0.0),
        (config and config.p9) or true,
        (config and config.useSoftPinning) or true,
        false,
        IsEntityAPed(to) or (config and config.isPed) or true,
        (config and config.rotationOrder) or 1,
        (config and config.syncRot) or true
    )
    return entity
end

function SpawnItemAndAttach(item, to, config)
    local entity = SpawnItem(item, config)
    AttachItem(entity, to, config)
    return entity
end

function removeItems(items)
    for k, v in pairs(items) do
        if v ~= nil and DoesEntityExist(v) then
            logger("Removing entity: " .. v, "debug")
            DeleteEntity(v)
        end
    end
end
