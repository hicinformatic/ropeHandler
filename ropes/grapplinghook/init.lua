local is_rope_throwed = false

function pull_coords()
    pullEntity(PlayerPedId(), current_usage.entity, { step = 10.0 })
end

function pull_mission()
    pull_coords()
end

function push_coords()
    pushEntity(PlayerPedId(), current_usage.entity, { step = 10.0 })
end

function push_mission()
    push_coords()
end

function grapplinghookTo_coords(coords, entity)
    logmsg(i18n("You throw the grappling hook on the ground"), "info")
    current_usage.entity_mode = "coords"
    local gh = SpawnItem(grapplinghookConfig.items.righthand.model, { coords = coords, entityFixed = true, invisible = true })
    SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], gh, {useCoords = true})
end

function grapplinghookTo_mission(coords, entity)
    grapplinghookTo_coords(coords, entity)
end

function grapplinghookTo_ped(coords, entity)
    logmsg(i18n("You throw the grappling hook on a ped"), "info")
    current_usage.entity_mode = "ped"
    local boneIndex, boneName = getPedBoneEntity(coords, entity)
    logger(i18n("Bone index: %s, Bone name: %s", boneIndex, boneName), "debug")
    SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], entity, {toBone = boneIndex})
end

function push_object()
    -- push object to player
    if current_usage.direction == "object_to_player" then
        pushEntity(current_usage.entity, items_named[grapplinghookConfig.items.righthand.itemname], { step = 10.0 })
        local new_coords = GetEntityCoords(current_usage.entity)
        if new_coords == current_usage.entity_coords then
            current_usage.direction = "player_to_object"
            pushEntity()
        else
            logmsg(i18n("You push the object"), "info")
        end
    -- push player to object
    else
        pushEntity(PlayerPedId(), current_usage.entity, { step = 10.0 })
        current_usage.direction = "object_to_player"
        logmsg(i18n("You push yourself"), "info")
    end
end

function pull_object()
    -- pull object to player
    if current_usage.direction == "object_to_player" then
        pullEntity(current_usage.entity, items_named[grapplinghookConfig.items.righthand.itemname], { step = 10.0 })
        local new_coords = GetEntityCoords(current_usage.entity)
        if new_coords == current_usage.entity_coords then
            current_usage.direction = "player_to_object"
            pull_object()
        else
            logmsg(i18n("You pull the object"), "info")
        end
    -- pull player to object
    else
        pullEntity(PlayerPedId(), current_usage.entity, { step = 10.0 })
        current_usage.direction = "object_to_player"
        logmsg(i18n("You pull yourself"), "info")
    end
end

function grapplinghookTo_object(coords, entity)
    logmsg(i18n("You throw the grappling hook on an object"), "info")
    current_usage.entity_mode = "object"
    current_usage.direction = "object_to_player"
    current_usage.entity_coords = GetEntityCoords(current_usage.entity)
    -- Exemple d'utilisation
    SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], entity, {useCoords = true})
end

function grapplinghookTo_vehicle(coords, entity)
    logmsg(i18n("You throw the grappling hook on a vehicle"), "info")
    current_usage.entity_mode = "vehicle"
    local boneIndex, boneName = getVehicleBoneEntity(coords, entity)
    logger(i18n("Bone index: %s, Bone name: %s", boneIndex, boneName), "debug")
    SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], entity, {toBone = bone})
end

local function grapplinghookThrow(coords, entity)
    is_rope_throwed = true
    removeItems({
        items_named[grapplinghookConfig.items.grapplinghook.itemname],
    })
    removeRopes({
        ropes_named[grapplinghookConfig.items.grapplinghook.ropename],
    })
    local entity_type = GetEntityType(entity)
    logger(i18n("Entity type: grapplinghookTo_%s", entity_type), "debug")
    _G["grapplinghookTo_" .. entity_type](coords, entity)
end

function grapplinghookInit()
    local ped = PlayerPedId()
    PlayAnimation(ped, grapplinghookConfig.animations.unthrow)

    -- Spawn items and ropes
    local righthand = SpawnItemAndAttach(grapplinghookConfig.items.righthand.model, ped, grapplinghookConfig.items.righthand)
    local lefthand = SpawnItemAndAttach(grapplinghookConfig.items.lefthand.model, ped, grapplinghookConfig.items.lefthand)
    local ropeitem = SpawnItemAndAttach(grapplinghookConfig.items.rope.model, ped, grapplinghookConfig.items.rope)
    SpawnRopeAndAttach(righthand, lefthand, grapplinghookConfig.items.rope)
    local grapplinghook = SpawnItem(grapplinghookConfig.items.grapplinghook.model, grapplinghookConfig.items.grapplinghook)
    SpawnRopeAndAttach(righthand, grapplinghook, grapplinghookConfig.items.grapplinghook)

end

function grapplinghookThread()
    DisableControls(grapplinghookConfig.controls)
    if IsDisabledControlPressed(0, 25) and not is_rope_throwed then
        local hit, coords, entity, bone = RayCastGamePlayCamera(grapplinghookConfig.distance)
        if hit ~= 0 then
            current_usage.entity = entity
            ShowCrosshair(grapplinghookConfig.crosshair, true)
            if grapplinghookConfig.crosshair.showLine then
                DrawLineToTarget(coords, grapplinghookConfig.crosshair.colorLine)
            end

            if IsDisabledControlJustPressed(0, 24) then
                TurnPedToTarget(PlayerPedId(), coords)
                PlayAnimation(PlayerPedId(), grapplinghookConfig.animations.throw)
                grapplinghookThrow(coords, entity)
            end

        else
            ShowCrosshair(grapplinghookConfig.crosshair)
            if IsDisabledControlJustPressed(0, 24) then
                logmsg(i18n("No target found or target too far"), "info")
            end
        end
    elseif is_rope_throwed then
        if IsDisabledControlJustPressed(0, 24) then
            logmsg(i18n("You get the grappling hook back"), "info")
            RopeHandlerRestart()
            is_rope_throwed = false
        elseif IsDisabledControlJustPressed(0, 96) then
            _G["pull_" .. current_usage.entity_mode]()
        elseif IsDisabledControlJustPressed(0, 97) then
            _G["push_" .. current_usage.entity_mode]()
        end
    end
end
