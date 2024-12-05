function grapplinghookClean()
    local ped = PlayerPedId()
    removeRopes({ ropes_named["rope_grapplinghook"] })
    removeItems({ items_named["item_grapplinghook"] })
    is_unique_thrown = nil
    PlayAnimation(ped, grapplinghookConfig.animations.unthrow)
    grapplinghookHang(ped)
end

-- If entity target is coords
function grapplinghookSpawn_coords(coords, entity)
    logmsg(i18n("You throw the grappling hook on coords"), "info")
    is_unique_thrown.attach = SpawnItem(grapplinghookConfig.items.righthand.model, entity, { coords = coords, itemFixed = true, invisible = true, itemname = "item_grapplinghook" })
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], is_unique_thrown.attach, {ropename = "rope_grapplinghook"})
end
function grapplinghookSpawn_mission(coords, entity) grapplinghookSpawn_coords(coords, entity) end

function grapplinghookTo_coords(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    moveEntity(method, PlayerPedId(), is_unique_thrown.attach, {
        step = getCfg(cfg, "step", 10.0),
        secure = getCfg(cfg, "secure", 2.0),
        rope = ropes_named["rope_grapplinghook"]
    })
end
function grapphlinghookTo_mission(method, cfg) grapphlinghookTo_coords(method, cfg) end

-- If entity target is a ped
function grapplinghookSpawn_ped(coords, entity)
    logmsg(i18n("You throw the grappling hook on a ped"), "info")
    local boneIndex, boneName = getPedBoneEntity(coords, entity)
    setRopableEntity(entity) -- i don't know how to drag dead ped
    is_unique_thrown.attach = SpawnItemAndAttach(grapplinghookConfig.items.righthand.model, entity, {bonePed = boneName, itemname = "item_grapplinghook"})
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], is_unique_thrown.attach, {ropename = "rope_grapplinghook"})
end

function grapplinghookTo_ped(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    SetPedToRagdoll(is_unique_thrown.entity, 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    moveEntity(method, is_unique_thrown.entity, PlayerPedId(), {
        step = getCfg(cfg, "step", 10.0),
        rope = ropes_named["rope_grapplinghook"]
    })
end

-- If entity target is a object
function grapplinghookSpawn_object(coords, entity)
    logmsg(i18n("You throw the grappling hook on an object"), "info")
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], entity, {ropename = "rope_grapplinghook"})
end

function grapplinghookTo_object(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    moveEntity(method, is_unique_thrown.entity, PlayerPedId(), {
        step = getCfg(cfg, "step", 10.0),
        rope = ropes_named["rope_grapplinghook"]
    })
    local new_coords = GetEntityCoords(is_unique_thrown.entity)
    if new_coords == is_unique_thrown.coords then
        moveEntity(method, PlayerPedId(), is_unique_thrown.entity, {
            step = getCfg(cfg, "step", 10.0),
            rope = ropes_named["rope_grapplinghook"]
        })
    else
        is_unique_thrown.coords = new_coords
    end
end


-- If target is a vehicle
function grapplinghookSpawn_vehicle(coords, entity)
    logmsg(i18n("You throw the spiderman %s on a vehicle", from), "info")
    local boneIndex, boneName = getVehicleBoneEntity(coords, entity)
    is_unique_thrown.attach = SpawnItemAndAttach(grapplinghookConfig.items.righthand.model, entity, {boneVehicle = boneName, itemname = "item_grapplinghook"})
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], is_unique_thrown.attach, {ropename = "rope_grapplinghook"})
end

function grapplinghookTo_vehicle(method, cfg)
    logger(i18n("You pull the grappling hook"), "debug")
    local speed = GetEntitySpeed(is_unique_thrown.entity)
    if speed > 7 then
        SetPedToRagdoll(PlayerPedId(), 3000, 3000, 0, false, false, false) -- Activer le ragdoll
    end
    moveEntity(method, PlayerPedId(), is_unique_thrown.entity, {
        step = getCfg(cfg, "step", 10.0),
        rope = ropes_named["rope_grapplinghook"]
    })
end

local function grapplinghookThrow(coords, entity, entity_type)
    removeItems({ items_named[grapplinghookConfig.items.grapplinghook.itemname] })
    removeRopes({ ropes_named[grapplinghookConfig.items.grapplinghook.ropename] })
    _G["grapplinghookSpawn_" .. entity_type](coords, entity)
end

function grapplinghookHang(ped)
    local grapplinghook = SpawnItem(grapplinghookConfig.items.grapplinghook.model, ped, grapplinghookConfig.items.grapplinghook)
    SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], grapplinghook, grapplinghookConfig.items.grapplinghook)
end

function grapplinghookInit()
    local ped = PlayerPedId()
    PlayAnimation(ped, grapplinghookConfig.animations.unthrow)
    -- Spawn items and ropes
    local righthand = SpawnItemAndAttach(grapplinghookConfig.items.righthand.model, ped, grapplinghookConfig.items.righthand)
    local lefthand = SpawnItemAndAttach(grapplinghookConfig.items.lefthand.model, ped, grapplinghookConfig.items.lefthand)
    local ropeitem = SpawnItemAndAttach(grapplinghookConfig.items.rope.model, ped, grapplinghookConfig.items.rope)
    SpawnRopeAndAttach(righthand, lefthand, grapplinghookConfig.items.rope)
    grapplinghookHang(ped)
end

function grapplinghookThread()
    disableControls(grapplinghookConfig.controls)
    if is_unique_thrown then
        --logger("is_unique_thrown", "debug")
        if IsDisabledControlJustPressed(0, 24) then
            logmsg(i18n("You get the grappling hook back"), "info")
            grapplinghookClean()
        elseif IsDisabledControlJustPressed(0, 96) or IsDisabledControlJustPressed(0, 97) then
            local method = IsDisabledControlJustPressed(0, 96) and "push" or "pull"
            local step = grapplinghookConfig.steps[is_unique_thrown["entity_type"]]
            _G["grapplinghookTo_" .. is_unique_thrown["entity_type"]](method, step)
        elseif is_unique_thrown.entity_type == "vehicle" then
            _G["grapplinghookTo_" .. is_unique_thrown["entity_type"]]("pull", step)
        end
    else
        local hit, coords, entity = RayCastGamePlayCamera(grapplinghookConfig.distance)
        ShowCrosshair(grapplinghookConfig.crosshair, hit ~= 0)
        if hit ~= 0 and IsDisabledControlJustPressed(0, 24) then
            is_unique_thrown = { from = "righthand", coords = coords, entity = entity, entity_type = getEntityTypeFormat(entity) }
            TurnPedToTarget(PlayerPedId(), coords)
            PlayAnimation(PlayerPedId(), grapplinghookConfig.animations.throw)
            grapplinghookThrow(coords, entity, is_unique_thrown.entity_type)
        end
    end
end
