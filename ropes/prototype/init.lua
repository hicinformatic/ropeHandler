
function prototypeClean(from)
    removeRopes({ ropes_named["rope_" .. from] })
    removeItems({ items_named["item_" .. from] })
    unsetRopableEntity(is_multiple_thrown[from].entity) -- i don't know how to drag dead ped
    is_multiple_thrown[from] = nil
end

-- If target is coords
function prototypeSpawn_coords(from, coords, entity, entity_type)
    logmsg(i18n("You throw the prototype %s on coords", from), "info")
    is_multiple_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
    local attach = SpawnItem(prototypeConfig.items.righthand.model, entity, {
        coords = coords,
        itemFixed = true,
        invisible = true,
        itemname = "item_" .. from
    })
    SpawnRopeAndAttach(items_named[prototypeConfig.items[from].itemname], attach, {ropename = "rope_" .. from})
end
function prototypeSpawn_mission(from, coords, entity, entity_type) prototypeSpawn_coords(from, coords, entity, "coords") end

function prototypeTo_coords(from, target, cfg)
    moveEntity("pull", PlayerPedId(), items_named["item_" .. from], { step = 2.0, secure = 2.0 })
end
function prototypeTo_mission(method, cfg) prototypeTo_coords(method, cfg) end

-- If target is a ped
function prototypeSpawn_ped(from, coords, entity, entity_type)
    logmsg(i18n("You throw the prototype %s on a ped", from), "info")
    is_multiple_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
    local boneIndex, boneName = getPedBoneEntity(coords, entity)
    setRopableEntity(entity) -- i don't know how to drag dead ped
    local attach = SpawnItemAndAttach(prototypeConfig.items.righthand.model, entity, {bonePed = boneName, itemname = "item_" .. from})
    SpawnRopeAndAttach(items_named[prototypeConfig.items[from].itemname], attach, {ropename = "rope_" .. from})
end

function prototypeTo_ped(from, target, cfg)
    logger("prototypeTo_ped", "debug")
    SetPedToRagdoll(is_multiple_thrown[from].entity, 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    moveEntityDynToEntityDyn("pull", PlayerPedId(), is_multiple_thrown[from].entity, { step = 2.0, secure = 2.0 })
end

-- If target is a vehicle
function prototypeSpawn_vehicle(from, coords, entity, entity_type)
    logmsg(i18n("You throw the prototype %s on a vehicle", from), "info")
    is_multiple_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
    local boneIndex, boneName = getVehicleBoneEntity(coords, entity)
    logger("boneName: " .. boneName, "debug")
    local attach = SpawnItemAndAttach(prototypeConfig.items.righthand.model, entity, {boneVehicle = boneName, itemname = "item_" .. from})
    SpawnRopeAndAttach(items_named[prototypeConfig.items[from].itemname], attach, {ropename = "rope_" .. from})
end

function prototypeTo_vehicle(from, target, cfg)
    logger("prototypeTo_ped", "debug")
    local speed = GetEntitySpeed(is_multiple_thrown[from].entity)
    if speed > 7 then
        SetPedToRagdoll(PlayerPedId(), 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    end
    moveEntity("pull", PlayerPedId(), items_named["item_" .. from], { step = 2.0, secure = 2.0, stopDistance = 5.0 })
end

-- If target is an object
function prototypeSpawn_object(from, coords, entity, entity_type)
    logmsg(i18n("You throw the prototype %s on an object", from), "info")
    is_multiple_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
    SpawnRopeAndAttach(items_named[prototypeConfig.items[from].itemname], entity, {ropename = "rope_" .. from})
end

function prototypeTo_object(from, target, cfg)
    moveEntityDynToEntityDyn("pull", PlayerPedId(), is_multiple_thrown[from].entity, { step = 2.0, secure = 2.0 })
end

function prototypeInit()
    local ped = PlayerPedId()
    PlayAnimation(ped, prototypeConfig.animations.unthrow)
    -- Spawn items and ropes
    local righthand = SpawnItemAndAttach(prototypeConfig.items.righthand.model, ped, prototypeConfig.items.righthand)
    local lefthand = SpawnItemAndAttach(prototypeConfig.items.lefthand.model, ped, prototypeConfig.items.lefthand)
    if not load_skin then
        local raygun1 = SpawnItemAndAttach(prototypeConfig.items.raygun1.model, ped, prototypeConfig.items.raygun1)
        local raygun2 = SpawnItemAndAttach(prototypeConfig.items.raygun2.model, ped, prototypeConfig.items.raygun2)
    end
end

function prototypeThread()
    disableControls(prototypeConfig.controls)
    local hit, coords, entity = RayCastGamePlayCamera(prototypeConfig.distance)
    ShowCrosshair(prototypeConfig.crosshair, hit ~= 0)
    if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) then
        local from = IsDisabledControlJustPressed(0, 24) and "lefthand" or "righthand"
        if is_multiple_thrown[from] then
            prototypeClean(from)
        else
            if hit ~= 0 then
                TurnPedToTarget(PlayerPedId(), coords)
                local entity_type = getEntityTypeFormat(entity)
                _G["prototypeSpawn_" .. entity_type](from, coords, entity, entity_type)
            end
        end
    end
    for hand, data in pairs(is_multiple_thrown) do
        -- prototype mode push player to the entity
        local step = prototypeConfig.steps[data["entity_type"]]
        _G["prototypeTo_" .. data.entity_type](hand, data, step)
    end
end
