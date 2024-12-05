ropes_loaded = {}
ropes_named = {}

function StartRope(rope)
    StartRopeUnwindingFront(rope) -- Permet de dérouler la corde
    -- ActivatePhysics(rope) -- Activer la physique sur la corde
    RopeLoadTextures() -- Charger les textures de la corde
end

function SpawnRope(from, to, cfg)
    fromPos = getCoordsEntity(from, {bonePed = cfg.fromBonePed, boneVehicle = cfg.fromBoneVehicle})
    toPos = getCoordsEntity(to, {bonePed = cfg.toBonePed, boneVehicle = cfg.toBoneVehicle})

    -- Calculer la distance entre les deux entités
    local distanceCalc = #(fromPos - toPos)
    local distance = getCfg(cfg, "distance", distanceCalc)
    local max_length = getCfg(cfg, "maxLength", distance)
    local direction = getCfg(cfg, "direction", vector3(0.0, 0.0, 0.0))

    -- Créer la corde
    local rope = AddRope(
        fromPos.x, fromPos.y, fromPos.z, -- Position initiale
        direction.x, direction.y, direction.z, -- Direction
        max_length, -- Longueur maximale (! RopeForceLength isn't working)
        getCfg(cfg, "ropeType", 4), -- Type de corde
        getCfg(cfg, "initLength", distance), -- Longueur initiale
        getCfg(cfg, "minLength", 0.0), -- Longueur minimale
        getCfg(cfg, "lengthChangeRate", 1.0), -- Taux d'enroulement
        getCfg(cfg, "onlyPPU", false), -- Inconnu
        getCfg(cfg, "collisionOn", false), -- Collision activée ?
        getCfg(cfg, "lockFromFront", (max_length == 0)), -- Rigide ?
        getCfg(cfg, "timeMultiplier", 1.0), -- Multiplieur de physique
        getCfg(cfg, "breakable", false), -- Corde cassable ?
        getCfg(cfg, "unkPtr", 0) -- Inconnu
    )

    if rope == nil then
        logger(i18n("Rope not created"), "warning")
        return
    end

    local ropename = getCfg(cfg, "ropename")
    if ropename then ropes_named[ropename] = rope end

    table.insert(ropes_loaded, rope)
    return rope, max_length, distance
end

function AttachRope(rope, from, to, cfg)
    local fromPos = getCfg(cfg, "fromPos", vector3(0.0, 0.0, 0.0))
    local toPos = getCfg(cfg, "toPos", vector3(0.0, 0.0, 0.0))
    local fromOffset = getCfg(cfg, "fromOffset")
    local toOffset = getCfg(cfg, "toOffset")

    if not isEntityInTypes(from, {"ped", "vehicle"}) then
        fromPos = getCoordsEntity(from, {bonePed = cfg.fromBonePed, boneVehicle = cfg.fromBoneVehicle})
    end
    if not isEntityInTypes(to, {"ped", "vehicle"}) then
        toPos = getCoordsEntity(to, {bonePed = cfg.toBonePed, boneVehicle = cfg.toBoneVehicle})
    end

    local ropeLength = getCfg(cfg, "ropeLength", GetDistanceBetweenCoords(fromPos, toPos, true))

    if fromOffset then fromPos = fromPos + fromOffset end
    if toOffset then toPos = toPos + toOffset end

    AttachEntitiesToRope(
        rope, -- Identifiant de la corde
        from, -- Première entité
        to, -- Seconde entité
        fromPos.x, fromPos.y, fromPos.z, -- Point d'attachement 1
        toPos.x, toPos.y, toPos.z, -- Point d'attachement 2 ajusté pour la main gauche
        10.0,
        getCfg(cfg, "physic", false), -- Physique activée
        getCfg(cfg, "collision", false), -- Collision activée
        getCfg(cfg, "fromBonePed", nil), -- Os de la première entité
        getCfg(cfg, "toBonePed", nil) -- Os de la seconde entité
    )
end

function SpawnRopeAndAttach(from, to, cfg)
    cfg = cfg or {}
    local rope, maxLength, distance = SpawnRope(from, to, cfg)
    cfg.ropeLength = distance
    AttachRope(rope, from, to, cfg)
    StartRope(rope)
    return rope
end

function SetRopeLength(rope, from, to, cfg)
    local fromPos = getCoordsEntity(from, cfg)
    local toPos = getCoordsEntity(from, cfg)
    local distance = GetDistanceBetweenCoords(fromPos, toPos, true)
    RopeForceLength(rope, 0.1)
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
