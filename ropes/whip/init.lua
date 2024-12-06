function whipClean()
    local ped = PlayerPedId()
    removeRopes({ ropes_named["rope_whip"] })
    removeItems({ items_named["item_whip"] })
    is_unique_thrown = nil
    PlayAnimation(ped, whipConfig.animations.unthrow)
    whipHang(ped)
end

-- If entity target is coords
function whipSpawn_coords(coords, entity)
    logmsg(i18n("You throw the grappling hook on coords"), "info")
    is_unique_thrown.attach = SpawnItem(whipConfig.items.righthand.model, entity, { coords = coords, itemFixed = true, invisible = true, itemname = "item_whip" })
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[whipConfig.items.righthand.itemname], is_unique_thrown.attach, {ropename = "rope_whip"})
end
function whipSpawn_mission(coords, entity) whipSpawn_coords(coords, entity) end

function whipTo_coords(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    moveEntity(method, PlayerPedId(), is_unique_thrown.attach, {
        step = getCfg(cfg, "step", 10.0),
        secure = getCfg(cfg, "secure", 2.0),
        rope = ropes_named["rope_whip"]
    })
end
function grapphlinghookTo_mission(method, cfg) grapphlinghookTo_coords(method, cfg) end

-- If entity target is a ped
function whipSpawn_ped(coords, entity)
    logmsg(i18n("You throw the grappling hook on a ped"), "info")
    local boneIndex, boneName = getPedBoneEntity(coords, entity)
    setRopableEntity(entity) -- i don't know how to drag dead ped
    is_unique_thrown.attach = SpawnItemAndAttach(whipConfig.items.righthand.model, entity, {bonePed = boneName, itemname = "item_whip"})
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[whipConfig.items.righthand.itemname], is_unique_thrown.attach, {ropename = "rope_whip"})
end

function whipTo_ped(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    SetPedToRagdoll(is_unique_thrown.entity, 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    moveEntity(method, is_unique_thrown.entity, PlayerPedId(), {
        step = getCfg(cfg, "step", 10.0),
        rope = ropes_named["rope_whip"]
    })
end

-- If entity target is a object
function whipSpawn_object(coords, entity)
    logmsg(i18n("You throw the grappling hook on an object"), "info")
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[whipConfig.items.righthand.itemname], entity, {ropename = "rope_whip"})
end

function whipTo_object(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    moveEntity(method, is_unique_thrown.entity, PlayerPedId(), {
        step = getCfg(cfg, "step", 10.0),
        rope = ropes_named["rope_whip"]
    })
    local new_coords = GetEntityCoords(is_unique_thrown.entity)
    if new_coords == is_unique_thrown.coords then
        moveEntity(method, PlayerPedId(), is_unique_thrown.entity, {
            step = getCfg(cfg, "step", 10.0),
            rope = ropes_named["rope_whip"]
        })
    else
        is_unique_thrown.coords = new_coords
    end
end


-- If target is a vehicle
function whipSpawn_vehicle(coords, entity)
    logmsg(i18n("You throw the spiderman %s on a vehicle", from), "info")
    local boneIndex, boneName = getVehicleBoneEntity(coords, entity)
    is_unique_thrown.attach = SpawnItemAndAttach(whipConfig.items.righthand.model, entity, {boneVehicle = boneName, itemname = "item_whip"})
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[whipConfig.items.righthand.itemname], is_unique_thrown.attach, {ropename = "rope_whip"})
end

function whipTo_vehicle(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    local speed = GetEntitySpeed(is_unique_thrown.entity)
    if speed > 7 then
        SetPedToRagdoll(PlayerPedId(), 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    end
    moveEntity(method, PlayerPedId(), is_unique_thrown.entity, {
        step = getCfg(cfg, "step", 10.0),
        rope = ropes_named["rope_whip"]
    })
end

local function whipThrow(coords, entity, entity_type)
    removeItems({ items_named[whipConfig.items.whip.itemname] })
    removeRopes({ ropes_named[whipConfig.items.whip.ropename] })
    _G["whipSpawn_" .. entity_type](coords, entity)
end

function whipHang(ped)
    local whip = SpawnItem(whipConfig.items.whip.model, ped, whipConfig.items.whip)
    SpawnRopeAndAttach(items_named[whipConfig.items.righthand.itemname], whip, whipConfig.items.whip)
end

function whipInit()
    local ped = PlayerPedId()
    PlayAnimation(ped, whipConfig.animations.unthrow)
    -- Spawn items and ropes
    local righthand = SpawnItemAndAttach(whipConfig.items.righthand.model, ped, whipConfig.items.righthand)
    local lefthand = SpawnItemAndAttach(whipConfig.items.lefthand.model, ped, whipConfig.items.lefthand)
    local ropeitem = SpawnItemAndAttach(whipConfig.items.rope.model, ped, whipConfig.items.rope)
    SpawnRopeAndAttach(righthand, lefthand, whipConfig.items.rope)
    whipHang(ped)
end

function whipThread()
    disableControls(whipConfig.controls)
    if is_unique_thrown then
        --logger("is_unique_thrown", "debug")
        if IsDisabledControlJustPressed(0, 24) then
            logmsg(i18n("You get the grappling hook back"), "info")
            whipClean()
        elseif IsDisabledControlJustPressed(0, 96) or IsDisabledControlJustPressed(0, 97) then
            local method = IsDisabledControlJustPressed(0, 96) and "push" or "pull"
            local step = whipConfig.steps[is_unique_thrown["entity_type"]]
            _G["whipTo_" .. is_unique_thrown["entity_type"]](method, step)
        elseif is_unique_thrown.entity_type == "vehicle" then
            _G["whipTo_" .. is_unique_thrown["entity_type"]]("pull", step)
        end
    else
        local hit, coords, entity = RayCastGamePlayCamera(whipConfig.distance)
        ShowCrosshair(whipConfig.crosshair, hit ~= 0)
        if hit ~= 0 and IsDisabledControlJustPressed(0, 24) then
            is_unique_thrown = { from = "righthand", coords = coords, entity = entity, entity_type = getEntityTypeFormat(entity) }
            TurnPedToTarget(PlayerPedId(), coords)
            PlayAnimation(PlayerPedId(), whipConfig.animations.throw)
            whipThrow(coords, entity, is_unique_thrown.entity_type)
        end
    end
end
