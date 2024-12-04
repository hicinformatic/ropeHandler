items_loaded = {}
items_named = {}

function getModel(model)
    RequestModel(model)  -- Charger le modèle
    while not HasModelLoaded(model) do
        Wait(500)  -- Attendre que le modèle soit chargé
    end
    return GetHashKey(model)
end

function SpawnItem(model, target, cfg)
    local entityToPos = target
    local initPos = getCfg(cfg, "coords", vector3(0.0, 0.0, 0.0))
    local bonePos = getCfg(cfg, "bonePos")
    local calcPos = getCfg(cfg, "calcPos")

    if bonePos then
        local boneIndex = GetPedBoneIndex(entityToPos, getBoneIndexByName(cfg.bonePos))
        initPos = GetWorldPositionOfEntityBone(entityToPos, boneIndex)
    elseif calcPos then
        initPos = GetEntityCoords(entityToPos)
    end

    if cfg and cfg.itemOffset then initPos = initPos + cfg.itemOffset end

    local modelhash = getModel(model)
    local entity = CreateObject(
        modelhash,
        initPos,
        (cfg and cfg.isNetwork) or true,
        (cfg and cfg.isPhysical) or true,
        (cfg and cfg.doorFlag) or false
    )

    if cfg and cfg.itemFixed then SetEntityCollision(entity, false, false) end
    if cfg and cfg.itemRotation then SetEntityRotation(entity, cfg.itemRotation, 2, true) end
    if cfg and cfg.noCollision then SetEntityCompletelyDisableCollision(entity, false, true) end
    if cfg and cfg.invisible then SetEntityVisible(entity, false, false) end
    if cfg and cfg.itemname then items_named[cfg.itemname] = entity end

    SetModelAsNoLongerNeeded(modelhash)
    table.insert(items_loaded, entity)
    return entity
end

function AttachItem(item, to, cfg)
    local boneIndex

    if cfg and cfg.bonePed then
        boneIndex = GetPedBoneIndex(to, getBoneIndexByName(cfg.bonePed))
    elseif cfg and cfg.boneVehicle then
        boneIndex = GetEntityBoneIndexByName(to, cfg.boneVehicle)
    end

    AttachEntityToEntity(
        item,
        to,
        boneIndex,
        (cfg and cfg.offset) or vector3(0.0, 0.0, 0.0),
        (cfg and cfg.rotation) or vector3(0.0, 0.0, 0.0),
        (cfg and cfg.p9) or true,
        (cfg and cfg.useSoftPinning) or true,
        false,
        IsEntityAPed(to) or (cfg and cfg.isPed) or true,
        (cfg and cfg.rotationOrder) or 1,
        (cfg and cfg.syncRot) or true
    )
    return item
end

function SpawnItemAndAttach(item, to, cfg)
    local entity = SpawnItem(item, to, cfg)
    AttachItem(entity, to, cfg)
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
