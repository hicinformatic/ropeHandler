items = {}
randitems = {}

function attachItemToPlayer(playerPed, playerPos, prop)
    -- Charger le modèle
    local model = prop.model
    local modelhash = GetHashKey(prop.model)
    local entityIndex = nil

    RequestModel(modelhash)  -- Charger le modèle
    while not HasModelLoaded(modelhash) do
        Wait(500)  -- Attendre que le modèle soit chargé
    end

    -- Créer l'objet et le placer juste devant le joueur
    offset = (prop and prop.offset) or vector3(0.0, 0.0, 0.0)
    rotation = (prop and prop.rotation) or vector3(0.0, 0.0, 0.0)
    local entity
    if prop.from then
        local from = items[prop.from]
        local fromPos = GetEntityCoords(from)
        fromPos = vector3(fromPos.x + offset.x, fromPos.y + offset.y, fromPos.z + offset.z)
        entity = CreateObject(modelhash, fromPos, true, true, false)
    else
        entity = CreateObject(modelhash, playerPos, true, true, false)
    end

    if prop.entity_rotation ~= nil then
        SetEntityRotation(entity, prop.entity_rotation.x, prop.entity_rotation.y, prop.entity_rotation.z, 2, true)
    end

    -- SetEntityCollision(entity, false, true)
    SetEntityVisible(entity, prop.visible or false, false)

    -- Attacher l'objet au joueur
    -- if prop.rope ~= nil then
        -- entityIndex = items[prop.rope]
        -- local entitycoords = GetEntityCoords(entityIndex)
        -- SetEntityCoords(entity, entitycoords.x + offset.x, entitycoords.y + offset.y, entitycoords.z + offset.z, true, true, true, true)
    if prop.bone ~= nil then
        logger("attach to bone: " .. prop.bone, "debug")
        entityIndex = GetPedBoneIndex(playerPed, prop.bone)
        AttachEntityToEntity(entity, playerPed, entityIndex, offset, rotation, true, true, false, true, 1, true)
    elseif prop.prop ~= nil then
        logger("attach to prop: " .. prop.prop, "debug")
        entityIndex = items[prop.prop]
        AttachEntityToEntity(entity, entityIndex, 0, offset, rotation, true, true, false, true, 1, true)
    end

    if prop.bone ~= nil or prop.prop ~= nil then
        SetModelAsNoLongerNeeded(modelhash)
    end

    table.insert(randitems, entity)
    return entity
end

function SpawnItemAtVehicle(vehicle, item, config)
    local model = item.model
    local modelhash = GetHashKey(model)

    RequestModel(modelhash)  -- Charger le modèle
    while not HasModelLoaded(modelhash) do
        Wait(500)  -- Attendre que le modèle soit chargé
    end

    local entity = CreateObject(modelhash, 0.0, 0.0, 0.0, true, true, false)
    AttachEntityToEntity(entity, vehicle, GetEntityBoneIndexByName(vehicle, "chassis"),
        (config and config.offset) or vector3(0.0, 0.0, 0.0),
        (config and config.rotation) or vector3(0.0, 0.0, 0.0),
        true, true, false, true, 1, true
    )

    SetModelAsNoLongerNeeded(modelhash)

    table.insert(randitems, entity)
    return entity
end

function SpawnItemAtBone(ped, bone, item, config)
    local model = item.model
    local modelhash = GetHashKey(model)

    RequestModel(modelhash)  -- Charger le modèle
    while not HasModelLoaded(modelhash) do
        Wait(500)  -- Attendre que le modèle soit chargé
    end
    local initPos = GetEntityCoords(ped)

    local entity = CreateObject(modelhash, 0.0, 0.0, 0.0, true, true, false)
    local entityIndex = GetPedBoneIndex(ped, bone)
    AttachEntityToEntity(entity, ped, entityIndex,
        (config and config.offset) or vector3(0.0, 0.0, 0.0),
        (config and config.rotation) or vector3(0.0, 0.0, 0.0),
        true, true, false, true, 1, true
    )

    SetModelAsNoLongerNeeded(modelhash)

    table.insert(randitems, entity)
    return entity
end

function SpawnItemAtCoords(coords, item, config)
    local model = item.model
    local modelhash = GetHashKey(model)

    RequestModel(modelhash)  -- Charger le modèle
    while not HasModelLoaded(modelhash) do
        Wait(500)  -- Attendre que le modèle soit chargé
    end

    local entity = CreateObject(modelhash, coords, true, true, false)
    SetEntityCollision(entity,
        (config and config.visible) or false,
        (config and config.collision) or false
    )

    SetModelAsNoLongerNeeded(modelhash)

    table.insert(randitems, entity)
    return entity
end

function loadItems(playerPed, playerPos, cfgitems, cfgorders)
    logger("Loading items")
    for _, key in ipairs(cfgorders) do
        logger("Loading item: " .. key, "debug")
        local item = cfgitems[key]
        items[key] = attachItemToPlayer(playerPed, playerPos, item)
    end
end

function removeItems(cfglist)
    if cfglist then
        for _, key in ipairs(cfglist) do
            if items[key] ~= nil and DoesEntityExist(items[key]) then
                logger("Removing entity: " .. key, "debug")
                logger("Entity: " .. items[key], "debug")
                DeleteEntity(items[key])
            end
        end
    else
        for k, v in pairs(randitems) do
            if v ~= nil and DoesEntityExist(v) then
                logger("Removing entity: " .. k, "debug")
                logger("Entity: " .. v, "debug")
                DeleteEntity(randitems[k])
            end
        end
        randitems = {}
        items = {}
    end
end
