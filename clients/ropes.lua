ropes_loaded = {}
ropes_named = {}


function GetCoordsFromTo(from, to, config)
    local fromBone, toBone

    if config and config.fromBonePed then
        fromBone = GetPedBoneIndex(from, getBoneIndexByName(config.fromBonePed))
        logger(i18n("From bone index: %s", fromBone), "info")
    end

    if config and config.toBonePed then
        toBone = GetPedBoneIndex(to, getBoneIndexByName(config.toBonePed))
        logger(i18n("To bone index: %s", toBone), "info")
    end

    -- Obtenir les positions globales des entités
    local fromPos = fromBone and GetWorldPositionOfEntityBone(from, fromBonePed) or GetEntityCoords(from)
    local toPos = toBone and GetWorldPositionOfEntityBone(to, toBonePed) or GetEntityCoords(to)
    return fromPos, toPos
end

function StartRope(rope)
    StartRopeUnwindingFront(rope) -- Permet de dérouler la corde
    ActivatePhysics(rope) -- Activer la physique sur la corde
    RopeLoadTextures() -- Charger les textures de la corde
end

function SpawnRope(from, to, config)
    fromPos = getCoordsEntity(from, {bonePed = config.fromBonePed, boneVehicle = config.fromBoneVehicle})
    toPos = getCoordsEntity(to, {bonePed = config.toBonePed, boneVehicle = config.toBoneVehicle})

    -- Calculer la distance entre les deux entités
    local distanceCalc = #(fromPos - toPos)
    local distance = getCfg(config, "distance", distanceCalc)
    local max_length = getCfg(config, "maxLength", distance)
    local direction = getCfg(config, "direction", vector3(0.0, 0.0, 0.0))

    -- Créer la corde
    local rope = AddRope(
        fromPos.x, fromPos.y, fromPos.z, -- Position initiale
        direction.x, direction.y, direction.z, -- Direction
        max_length, -- Longueur maximale
        getCfg(config, "ropeType", 4), -- Type de corde
        getCfg(config, "initLength", distance), -- Longueur initiale
        getCfg(config, "minLength", 0.0), -- Longueur minimale
        getCfg(config, "lengthChangeRate", 1.0), -- Taux d'enroulement
        getCfg(config, "onlyPPU", false), -- Inconnu
        getCfg(config, "collisionOn", false), -- Collision activée ?
        getCfg(config, "lockFromFront", (max_length == 0)), -- Rigide ?
        getCfg(config, "timeMultiplier", 1.0), -- Multiplieur de physique
        getCfg(config, "breakable", false), -- Corde cassable ?
        getCfg(config, "unkPtr", 0) -- Inconnu
    )

    if rope == nil then
        logger(i18n("Rope not created"), "warning")
        return
    end

    local ropename = getCfg(config, "ropename")
    if ropename then ropes_named[ropename] = rope end

    table.insert(ropes_loaded, rope)
    return rope, max_length, distance
end

function AttachRope(rope, from, to, config)
    local fromPos = getCfg(config, "fromPos", vector3(0.0, 0.0, 0.0))
    local toPos = getCfg(config, "toPos", vector3(0.0, 0.0, 0.0))
    local fromOffset = getCfg(config, "fromOffset")
    local toOffset = getCfg(config, "toOffset")

    if not isEntityInTypes(from, {"ped", "vehicle"}) then
        fromPos = getCoordsEntity(from, {bonePed = config.fromBonePed, boneVehicle = config.fromBoneVehicle})
    end
    if not isEntityInTypes(to, {"ped", "vehicle"}) then
        toPos = getCoordsEntity(to, {bonePed = config.toBonePed, boneVehicle = config.toBoneVehicle})
    end

    local ropeLength = getCfg(config, "ropeLength", GetDistanceBetweenCoords(fromPos, toPos, true))
    logger(i18n("Rope length: %s", ropeLength), "debug")

    if fromOffset then fromPos = fromPos + fromOffset end
    if toOffset then toPos = toPos + toOffset end

    AttachEntitiesToRope(
        rope, -- Identifiant de la corde
        from, -- Première entité
        to, -- Seconde entité
        fromPos.x, fromPos.y, fromPos.z, -- Point d'attachement 1
        toPos.x, toPos.y, toPos.z, -- Point d'attachement 2 ajusté pour la main gauche
        10.0,
        getCfg(config, "physic", false), -- Physique activée
        getCfg(config, "collision", false), -- Collision activée
        getCfg(config, "fromBonePed", nil), -- Os de la première entité
        getCfg(config, "toBonePed", nil) -- Os de la seconde entité
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
