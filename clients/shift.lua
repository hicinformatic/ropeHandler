function moveEntity(mode, from, to, cfg)
    local fromPos = GetEntityCoords(from)
    local toPos = GetEntityCoords(to)
    local distance = #(fromPos - toPos)
    local force = getCfg(cfg, "step", 0.1)
    local stopDistance = getCfg(cfg, "stopDistance")
    local secureDistance = getCfg(cfg, "secureDistance")
    local direction

    if stopDistance and distance < stopDistance then
        logger(i18n("Stop distance reached"), "info")
        return
    end

    if secureDistance and distance < secureDistance then
        logger(i18n("Secure distance reached"), "info")
        force = 0.01
    end

    if mode == "pull" then
        direction = (toPos - fromPos) / distance
    else
        direction = (fromPos - toPos) / distance
    end
    ApplyForceToEntity(from, 1, direction.x * force, direction.y * force, direction.z * force, 0, 0, 0, 0, false, true, true, false, true)
end

function moveEntityDynToEntityDyn(mode, from, to, cfg)
    local fromPos = GetEntityCoords(from)
    local toPos = GetEntityCoords(to)
    local distance = #(fromPos - toPos)
    local force = getCfg(cfg, "step", 0.1)
    local stopDistance = getCfg(cfg, "stopDistance")
    local secureDistance = getCfg(cfg, "secureDistance")
    local directionFrom, directionTo

    if stopDistance and distance < stopDistance then
        logger(i18n("Stop distance reached"), "info")
        return
    end

    if secureDistance and distance < secureDistance then
        logger(i18n("Secure distance reached"), "info")
        force = 0.01
    end

    if mode == "pull" then
        directionFrom = (toPos - fromPos) / distance
        directionTo = (fromPos - toPos) / distance
    else
        directionFrom = (fromPos - toPos) / distance
        directionTo = (toPos - fromPos) / distance
    end

    ApplyForceToEntity(from, 1, directionFrom.x * force, directionFrom.y * force, directionFrom.z * force, 0, 0, 0, 0, false, true, true, false, true)
    ApplyForceToEntity(to, 1, directionTo.x * force, directionTo.y * force, directionTo.z * force, 0, 0, 0, 0, false, true, true, false, true)
end
