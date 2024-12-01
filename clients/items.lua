items_loaded = {}

function getModel(model)
    RequestModel(model)  -- Charger le modèle
    while not HasModelLoaded(model) do
        Wait(500)  -- Attendre que le modèle soit chargé
    end
    return GetHashKey(model)
end

function SpawnItem(item, config)
    local ped = PlayerPedId()
    local initPos

    if config and config.bonePos then
        local boneIndex = GetPedBoneIndex(ped, GetBoneIndexByName(config.bonePos))
        initPos = GetWorldPositionOfEntityBone(ped, boneIndex)
    else
        initPos = GetEntityCoords(ped)
    end

    if config and config.entityOffset then
        initPos = initPos + config.entityOffset
    end

    local modelhash = getModel(item)
    local entity = CreateObject(
        modelhash,
        (config and config.axis) or initPos,
        (config and config.isNetwork) or true,
        (config and config.isPhysical) or true,
        (config and config.doorFlag) or false
    )

    if config and config.entityRotation then
         SetEntityRotation(entity, config.entityRotation, 2, true)
     end

    if config and config.noCollision then
        SetEntityCompletelyDisableCollision(entity, false, true)
    end

    if config and config.invisible then
        SetEntityVisible(entity, false, false)
    end

    table.insert(items_loaded, entity)
    SetModelAsNoLongerNeeded(modelhash)
    return entity
end

function AttachItem(entity, to, config)
    local boneIndex
    if config and config.bone then
        boneIndex = GetPedBoneIndex(to, GetBoneIndexByName(config.bone))
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
