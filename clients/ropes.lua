ropes = {}
randropes = {}
ropethrowed = nil

function attachRopeBetweenProps(playerPed, playerPos, rope)
    local from = items[rope.from]
    local fromPos = GetEntityCoords(from)
    local to = items[rope.to]
    local toPos = GetEntityCoords(to)
    local ropeLength = (rope and rope.ropelength) or GetDistanceBetweenCoords(fromPos, toPos, true)
    logger("Rope length: " .. ropeLength, "debug")

    local maxRopeLength
    if rope.maxRopeLength then
        maxRopeLength = ropeLength
    else
        maxRopeLength = rope.max or 2.0
    end

    ropeHandle = AddRope(
        fromPos, -- Position initiale
        vector3(0.0, 0.0, 0.0), -- Offset
        maxRopeLength, -- Longueur maximale
        rope.type or 4, -- Type de corde (4 = souple)
        ropeLength, -- initLength : Longueur initiale de la corde
        rope.min or 0.01, -- minLength : Longueur minimale que la corde peut atteindre
        rope.rate or 1.0, -- lengthChangeRate : Vitesse d'enroulement/déroulement
        false, -- onlyPPU : Inconnu, mettre false par défaut
        rope.collision or false, -- collisionOn : Activer les collisions de la corde
        rope.lock or false, -- lockFromFront : Si true, la corde devient rigide si maxLength est 0
        rope.multiplier or 1.0, -- timeMultiplier : Multiplicateur de physique
        rope.breakable or false, -- breakable : Permet de casser la corde par des tirs
        0 -- unkPtr : Inconnu, toujours 0
    )

    if ropeHandle == nil then
        logger("Rope not created", "warning")
        return
    end

    if rope.fromOffset then
        fromPos = vector3(fromPos.x + rope.fromOffset.x, fromPos.y + rope.fromOffset.y, fromPos.z + rope.fromOffset.z)
    end

    if rope.toOffset then
        toPos = vector3(toPos.x + rope.toOffset.x, toPos.y + rope.toOffset.y, toPos.z + rope.toOffset.z)
    end

    AttachEntitiesToRope(
        ropeHandle, -- Corde créée
        from, to, -- Entités à attacher
        fromPos, -- Point d'attachement 1
        toPos -- Point d'attachement 2 ajusté pour la main gauche
    )

    -- Activer la physique et permettre à la corde de pendre naturellement
    StartRopeUnwindingFront(ropeHandle) -- Permet de dérouler la corde
    RopeForceLength(ropeHandle, ropeLength + 0.5) -- Ajuste la longueur avec une légère extension
    ActivatePhysics(ropeHandle) -- Activer la physique sur la corde
    RopeLoadTextures() -- Charger les textures de la corde

    table.insert(randropes, ropeHandle)
    return ropeHandle
end

function SpawnRopeFromTo(from, to, config)
    local fromPos = GetEntityCoords(from)
    local toPos = GetEntityCoords(to)
    local ropeLength = (config and config.ropelength) or GetDistanceBetweenCoords(fromPos, toPos, true)
    logger("Rope length: " .. ropeLength, "debug")

    local maxRopeLength
    if config and config.maxRopeLength then
        maxRopeLength = ropeLength
    else
        maxRopeLength = (config and config.max) or 2.0
    end

    ropeHandle = AddRope(
        fromPos, -- Position initiale
        vector3(0.0, 0.0, 0.0), -- Offset
        maxRopeLength, -- Longueur maximale
        (config and config.type) or 1, -- Type de corde (4 = souple)
        ropeLength, -- initLength : Longueur initiale de la corde
        (config and config.min) or 0.01, -- minLength : Longueur minimale que la corde peut atteindre
        (config and config.rate) or 1.0, -- lengthChangeRate : Vitesse d'enroulement/déroulement
        false, -- onlyPPU : Inconnu, mettre false par défaut
        (config and config.collision) or false, -- collisionOn : Activer les collisions de la corde
        (config and config.lock) or false, -- lockFromFront : Si true, la corde devient rigide si maxLength est 0
        (config and config.multiplier) or 1.0, -- timeMultiplier : Multiplicateur de physique
        (config and config.breakable) or false, -- breakable : Permet de casser la corde par des tirs
        0 -- unkPtr : Inconnu, toujours 0
    )

    if ropeHandle == nil then
        logger("Rope not created", "warning")
        return
    end

    if config and config.fromOffset then
        fromPos = vector3(
            fromPos.x + config.fromOffset.x,
            fromPos.y + config.fromOffset.y,
            fromPos.z + config.fromOffset.z
        )
    end

    if config and config.toOffset then
        toPos = vector3(
            toPos.x + config.toOffset.x,
            toPos.y + config.toOffset.y,
            toPos.z + config.toOffset.z
        )
    end

    AttachEntitiesToRope(
        ropeHandle, -- Corde créée
        from, to, -- Entités à attacher
        fromPos, -- Point d'attachement 1
        toPos -- Point d'attachement 2 ajusté pour la main gauche
    )

    -- Activer la physique et permettre à la corde de pendre naturellement
    StartRopeUnwindingFront(ropeHandle) -- Permet de dérouler la corde
    RopeForceLength(ropeHandle, ropeLength + 0.5) -- Ajuste la longueur avec une légère extension
    ActivatePhysics(ropeHandle) -- Activer la physique sur la corde
    RopeLoadTextures() -- Charger les textures de la corde

    table.insert(randropes, ropeHandle)
    return ropeHandle
end

-- Fonction pour ajuster la longueur de la corde
function adjustRopeLength(ropeId, newLength)
    logger("Adjusting rope length: " .. newLength, "debug")
    -- Si la longueur est valide, modifier la corde
    if ropeId ~= nil then
        RopeForceLength(ropeId, newLength)
    end
end
-- Fonction pour réduire la longueur de la corde
function decreaseRope(ropeId)
    newLength = GetRopeLength(ropeId) - 1.0
    if newLength < 1.0 then newLength = 1.0 end
    adjustRopeLength(ropeId, 1.0)
end

-- Fonction pour augmenter la longueur de la corde
function increaseRope(ropeId)
    newLength = GetRopeLength(ropeId) + 1.0
    adjustRopeLength(ropeId, 1.0)
end

function removeRopes(cfglist)
    logger("Removing ropes", "debug")
    if cfglist then
        for _, key in ipairs(cfglist) do
            if ropes[key] ~= nil and DoesRopeExist(ropes[key]) then
                logger("Removing rope: " .. key, "debug")
                logger("Rope: " .. ropes[key], "debug")
                DeleteRope(ropes[key])
            end
        end
    else
        for k, v in pairs(randropes) do
            if v ~= nil and DoesRopeExist(v) then
                logger("Removing rope: " .. k, "debug")
                logger("Rope: " .. v, "debug")
                DeleteRope(v)
            end
        end
        randropes = {}
        ropes = {}
    end
end

function loadRopes(playerPed, playerPos, cfgropes)
    logger("loadRopes", "debug")
    for k, v in pairs(cfgropes) do
        ropes[k] = attachRopeBetweenProps(playerPed, playerPos, v)
    end
end
