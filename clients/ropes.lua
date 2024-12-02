ropes_loaded = {}
ropes_named = {}

function GetCoordsFromTo(from, to, config)
    local fromBone = config and config.fromBone and GetPedBoneIndex(from, GetBoneIndexByName(config.fromBone)) or nil
    logger(i18n("From bone index: %s", fromBone), "info")
    local toBone = config and config.toBone and GetPedBoneIndex(to,GetBoneIndexByName(config.toBone)) or nil
    logger(i18n("To bone index: %s", toBone), "info")

    -- Obtenir les positions globales des entités
    local fromPos = fromBone and GetWorldPositionOfEntityBone(from, fromBone) or GetEntityCoords(from)
    logger(i18n("From position: %s", fromPos), "info")
    local toPos = toBone and GetWorldPositionOfEntityBone(to, toBone) or GetEntityCoords(to)
    logger(i18n("To position: %s", toPos), "info")
    return fromPos, toPos
end

function StartRope(rope)
    StartRopeUnwindingFront(rope) -- Permet de dérouler la corde
    ActivatePhysics(rope) -- Activer la physique sur la corde
    RopeLoadTextures() -- Charger les textures de la corde
end

function SpawnRope(from, to, config)
    local fromPos, toPos = GetCoordsFromTo(from, to, config)
    -- Calculer la distance entre les deux entités
    local distanceCalc = #(fromPos - toPos)
    logger(i18n("Rope distance: %s", distanceCalc), "info")
    local distance = (config and config.distance) or distanceCalc
    logger(i18n("Rope distance: %s", distance), "info")
    local max_length = (config and config.maxLength) or distance
    logger(i18n("Rope max length: %s", max_length), "info")

    -- Créer la corde
    local rope = AddRope(
        fromPos.x, fromPos.y, fromPos.z, -- Position initiale
        (config and config.direction) or 0.0, 0.0, 0.0, -- Direction initiale
        max_length, -- Longueur maximale
        (config and config.ropeType) or 4, -- Type de corde
        (config and config.initLength) or distance, -- Longueur initiale
        (config and config.minLength) or 0.0, -- Longueur minimale
        (config and config.lengthChangeRate) or 1.0, -- Taux d'enroulement
        (config and config.onlyPPU) or false, -- Inconnu
        (config and config.collisionOn) or false, -- Collision activée ?
        (config and config.lockFromFront) or (max_length == 0), -- Rigide ?
        (config and config.timeMultiplier) or 1.0, -- Multiplieur de physique
        (config and config.breakable) or false, -- Corde cassable ?
        (config and config.unkPtr) or 0 -- Inconnu
    )

    if rope == nil then
        logger(i18n("Rope not created"), "warning")
        return
    else
        logger(i18n("Rope created: %s", rope), "debug")
    end

    table.insert(ropes_loaded, rope)

    if config and config.ropename then
        ropes_named[config.ropename] = rope
    end

    return rope, max_length, distance
end

function AttachRope(rope, from, to, config)
    local fromPos = vector3(0.0, 0.0, 0.0)
    local toPos = vector3(0.0, 0.0, 0.0)

    if config and config.useCoords then
        local gfromPos, gtoPos = GetCoordsFromTo(from, to, config)
        if isEntityInTypes(from, {"object", "coords"}) then
            logger(i18n("Using coords for from entity"), "debug")
            fromPos = gfromPos
        end
        if isEntityInTypes(to, {"object", "coords"}) then
            logger(i18n("Using coords for to entity"), "debug")
            toPos = gtoPos
        end
    end

    if config and config.fromOffset then
        logger(i18n("Offset from: %s", config.fromOffset), "debug")
        fromPos = fromPos + config.fromOffset
    end

    if config and config.toOffset then
        logger(i18n("Offset to: %s", config.toOffset), "debug")
        toPos = toPos + config.toOffset
    end

    local ropeLength = (config and config.ropeLength) or GetDistanceBetweenCoords(fromPos, toPos, true)
    logger(i18n("Rope length: %s", ropeLength), "debug")

    AttachEntitiesToRope(
        rope, -- Identifiant de la corde
        from, -- Première entité
        to, -- Seconde entité
        fromPos, -- Point d'attachement 1
        toPos, -- Point d'attachement 2 ajusté pour la main gauche
        ropeLength,
        (config and config.physic) or false, -- Physique activée
        (config and config.collision) or false, -- Collision activée
        (config and config.fromBone) or nil, -- Os de la première entité
        (config and config.toBone) or nil -- Os de la seconde entité
    )
end

function SpawnRopeAndAttach(from, to, config)
    config = config or {}
    local rope, maxLength, distance = SpawnRope(from, to, config)
    config.ropeLength = distance
    AttachRope(rope, from, to, config)
    StartRope(rope)
    return rope
end

function removeRopes(ropes)
    for k, v in pairs(ropes) do
        if v ~= nil and DoesRopeExist(v) then
            logger("Removing rope: " .. k, "debug")
            logger("Rope: " .. v, "debug")
            DeleteRope(v)
        end
    end
end
