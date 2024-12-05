
function spidermanClean(from)
    removeRopes({ ropes_named["rope_" .. from] })
    removeItems({ items_named["item_" .. from] })
    unsetRopableEntity(is_multiple_thrown[from].entity) -- i don't know how to drag dead ped
    is_multiple_thrown[from] = nil
end

-- If target is coords
function spidermanSpawn_coords(from, coords, entity, entity_type)
    logmsg(i18n("You throw the spiderman %s on coords", from), "info")
    is_multiple_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
    local attach = SpawnItem(spidermanConfig.items.righthand.model, entity, {
        coords = coords,
        itemFixed = true,
        invisible = true,
        itemname = "item_" .. from
    })
    SpawnRopeAndAttach(items_named[spidermanConfig.items[from].itemname], attach, {ropename = "rope_" .. from})
end
function spidermanSpawn_mission(from, coords, entity, entity_type) spidermanSpawn_coords(from, coords, entity, "coords") end

function spidermanTo_coords(from, target, cfg)
    moveEntity("pull", PlayerPedId(), items_named["item_" .. from], { step = 2.0, secure = 2.0 })
end
function spidermanTo_mission(method, cfg) spidermanTo_coords(method, cfg) end

-- If target is a ped
function spidermanSpawn_ped(from, coords, entity, entity_type)
    logmsg(i18n("You throw the spiderman %s on a ped", from), "info")
    is_multiple_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
    local boneIndex, boneName = getPedBoneEntity(coords, entity)
    setRopableEntity(entity) -- i don't know how to drag dead ped
    local attach = SpawnItemAndAttach(spidermanConfig.items.righthand.model, entity, {bonePed = boneName, itemname = "item_" .. from})
    SpawnRopeAndAttach(items_named[spidermanConfig.items[from].itemname], attach, {ropename = "rope_" .. from})
end

function spidermanTo_ped(from, target, cfg)
    logger("spidermanTo_ped", "debug")
    SetPedToRagdoll(is_multiple_thrown[from].entity, 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    moveEntityDynToEntityDyn("pull", PlayerPedId(), is_multiple_thrown[from].entity, { step = 2.0, secure = 2.0 })
end

-- If target is a vehicle
function spidermanSpawn_vehicle(from, coords, entity, entity_type)
    logmsg(i18n("You throw the spiderman %s on a vehicle", from), "info")
    is_multiple_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
    local boneIndex, boneName = getVehicleBoneEntity(coords, entity)
    logger("boneName: " .. boneName, "debug")
    local attach = SpawnItemAndAttach(spidermanConfig.items.righthand.model, entity, {boneVehicle = boneName, itemname = "item_" .. from})
    SpawnRopeAndAttach(items_named[spidermanConfig.items[from].itemname], attach, {ropename = "rope_" .. from})
end

function spidermanTo_vehicle(from, target, cfg)
    logger("spidermanTo_ped", "debug")
    local speed = GetEntitySpeed(is_multiple_thrown[from].entity)
    if speed > 7 then
        SetPedToRagdoll(PlayerPedId(), 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    end
    moveEntity("pull", PlayerPedId(), items_named["item_" .. from], { step = 2.0, secure = 2.0, stopDistance = 5.0 })
end

-- If target is an object
function spidermanSpawn_object(from, coords, entity, entity_type)
    logmsg(i18n("You throw the spiderman %s on an object", from), "info")
    is_multiple_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
    SpawnRopeAndAttach(items_named[spidermanConfig.items[from].itemname], entity, {ropename = "rope_" .. from})
end

function spidermanTo_object(from, target, cfg)
    moveEntityDynToEntityDyn("pull", PlayerPedId(), is_multiple_thrown[from].entity, { step = 2.0, secure = 2.0 })
end

function spidermanInit()
    local ped = PlayerPedId()
    PlayAnimation(ped, spidermanConfig.animations.unthrow)
    -- Spawn items and ropes
    local righthand = SpawnItemAndAttach(spidermanConfig.items.righthand.model, ped, spidermanConfig.items.righthand)
    local lefthand = SpawnItemAndAttach(spidermanConfig.items.lefthand.model, ped, spidermanConfig.items.lefthand)
    if not load_skin then
        local raygun1 = SpawnItemAndAttach(spidermanConfig.items.raygun1.model, ped, spidermanConfig.items.raygun1)
        local raygun2 = SpawnItemAndAttach(spidermanConfig.items.raygun2.model, ped, spidermanConfig.items.raygun2)
    end
end

function spidermanThread()
    disableControls(spidermanConfig.controls)
    local hit, coords, entity = RayCastGamePlayCamera(spidermanConfig.distance)
    ShowCrosshair(spidermanConfig.crosshair, hit ~= 0)
    if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) then
        local from = IsDisabledControlJustPressed(0, 24) and "lefthand" or "righthand"
        if is_multiple_thrown[from] then
            spidermanClean(from)
        else
            if hit ~= 0 then
                TurnPedToTarget(PlayerPedId(), coords)
                local entity_type = getEntityTypeFormat(entity)
                _G["spidermanSpawn_" .. entity_type](from, coords, entity, entity_type)
            end
        end
    end
    for hand, data in pairs(is_multiple_thrown) do
        -- spiderman mode push player to the entity
        local step = spidermanConfig.steps[data["entity_type"]]
        _G["spidermanTo_" .. data.entity_type](hand, data, step)
    end
end
