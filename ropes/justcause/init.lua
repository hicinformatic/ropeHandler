function justcauseClean()
    local ped = PlayerPedId()
    removeRopes({ ropes_named["rope_justcause"] })
    removeItems({ items_named["item_justcause"] })
    is_unique_thrown = nil
    PlayAnimation(ped, justcauseConfig.animations.unthrow)
    justcauseHang(ped)
end

-- If entity target is coords
function justcauseSpawn_coords(coords, entity)
    logmsg(i18n("You throw the grappling hook on coords"), "info")
    is_unique_thrown.attach = SpawnItem(justcauseConfig.items.righthand.model, entity, { coords = coords, itemFixed = true, invisible = true, itemname = "item_justcause" })
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[justcauseConfig.items.righthand.itemname], is_unique_thrown.attach, {ropename = "rope_justcause"})
end
function justcauseSpawn_mission(coords, entity) justcauseSpawn_coords(coords, entity) end

function justcauseTo_coords(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    moveEntity(method, PlayerPedId(), is_unique_thrown.attach, {
        step = getCfg(cfg, "step", 10.0),
        secure = getCfg(cfg, "secure", 2.0),
        rope = ropes_named["rope_justcause"]
    })
end
function grapphlinghookTo_mission(method, cfg) grapphlinghookTo_coords(method, cfg) end

-- If entity target is a ped
function justcauseSpawn_ped(coords, entity)
    logmsg(i18n("You throw the grappling hook on a ped"), "info")
    local boneIndex, boneName = getPedBoneEntity(coords, entity)
    setRopableEntity(entity) -- i don't know how to drag dead ped
    is_unique_thrown.attach = SpawnItemAndAttach(justcauseConfig.items.righthand.model, entity, {bonePed = boneName, itemname = "item_justcause"})
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[justcauseConfig.items.righthand.itemname], is_unique_thrown.attach, {ropename = "rope_justcause"})
end

function justcauseTo_ped(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    SetPedToRagdoll(is_unique_thrown.entity, 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    moveEntity(method, is_unique_thrown.entity, PlayerPedId(), {
        step = getCfg(cfg, "step", 10.0),
        rope = ropes_named["rope_justcause"]
    })
end

-- If entity target is a object
function justcauseSpawn_object(coords, entity)
    logmsg(i18n("You throw the grappling hook on an object"), "info")
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[justcauseConfig.items.righthand.itemname], entity, {ropename = "rope_justcause"})
end

function justcauseTo_object(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    moveEntity(method, is_unique_thrown.entity, PlayerPedId(), {
        step = getCfg(cfg, "step", 10.0),
        rope = ropes_named["rope_justcause"]
    })
    local new_coords = GetEntityCoords(is_unique_thrown.entity)
    if new_coords == is_unique_thrown.coords then
        moveEntity(method, PlayerPedId(), is_unique_thrown.entity, {
            step = getCfg(cfg, "step", 10.0),
            rope = ropes_named["rope_justcause"]
        })
    else
        is_unique_thrown.coords = new_coords
    end
end


-- If target is a vehicle
function justcauseSpawn_vehicle(coords, entity)
    logmsg(i18n("You throw the spiderman %s on a vehicle", from), "info")
    local boneIndex, boneName = getVehicleBoneEntity(coords, entity)
    is_unique_thrown.attach = SpawnItemAndAttach(justcauseConfig.items.righthand.model, entity, {boneVehicle = boneName, itemname = "item_justcause"})
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[justcauseConfig.items.righthand.itemname], is_unique_thrown.attach, {ropename = "rope_justcause"})
end

function justcauseTo_vehicle(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    local speed = GetEntitySpeed(is_unique_thrown.entity)
    if speed > 7 then
        SetPedToRagdoll(PlayerPedId(), 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    end
    moveEntity(method, PlayerPedId(), is_unique_thrown.entity, {
        step = getCfg(cfg, "step", 10.0),
        rope = ropes_named["rope_justcause"]
    })
end

local function justcauseThrow(coords, entity, entity_type)
    removeItems({ items_named[justcauseConfig.items.justcause.itemname] })
    removeRopes({ ropes_named[justcauseConfig.items.justcause.ropename] })
    _G["justcauseSpawn_" .. entity_type](coords, entity)
end

function justcauseHang(ped)
    local justcause = SpawnItem(justcauseConfig.items.justcause.model, ped, justcauseConfig.items.justcause)
    SpawnRopeAndAttach(items_named[justcauseConfig.items.righthand.itemname], justcause, justcauseConfig.items.justcause)
end

function justcauseInit()
    local ped = PlayerPedId()
    PlayAnimation(ped, justcauseConfig.animations.unthrow)
    -- Spawn items and ropes
    local righthand = SpawnItemAndAttach(justcauseConfig.items.righthand.model, ped, justcauseConfig.items.righthand)
    local lefthand = SpawnItemAndAttach(justcauseConfig.items.lefthand.model, ped, justcauseConfig.items.lefthand)
    local ropeitem = SpawnItemAndAttach(justcauseConfig.items.rope.model, ped, justcauseConfig.items.rope)
    SpawnRopeAndAttach(righthand, lefthand, justcauseConfig.items.rope)
    justcauseHang(ped)
end

function justcauseThread()
    disableControls(justcauseConfig.controls)
    if is_unique_thrown then
        --logger("is_unique_thrown", "debug")
        if IsDisabledControlJustPressed(0, 24) then
            logmsg(i18n("You get the grappling hook back"), "info")
            justcauseClean()
        elseif IsDisabledControlJustPressed(0, 96) or IsDisabledControlJustPressed(0, 97) then
            local method = IsDisabledControlJustPressed(0, 96) and "push" or "pull"
            local step = justcauseConfig.steps[is_unique_thrown["entity_type"]]
            _G["justcauseTo_" .. is_unique_thrown["entity_type"]](method, step)
        elseif is_unique_thrown.entity_type == "vehicle" then
            _G["justcauseTo_" .. is_unique_thrown["entity_type"]]("pull", step)
        end
    else
        local hit, coords, entity = RayCastGamePlayCamera(justcauseConfig.distance)
        ShowCrosshair(justcauseConfig.crosshair, hit ~= 0)
        if hit ~= 0 and IsDisabledControlJustPressed(0, 24) then
            is_unique_thrown = { from = "righthand", coords = coords, entity = entity, entity_type = getEntityTypeFormat(entity) }
            TurnPedToTarget(PlayerPedId(), coords)
            PlayAnimation(PlayerPedId(), justcauseConfig.animations.throw)
            justcauseThrow(coords, entity, is_unique_thrown.entity_type)
        end
    end
end
