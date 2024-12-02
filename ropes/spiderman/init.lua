
is_thrown = {}

function spidermanThrowTo_coords(from, coords, entity, entity_type)
    logmsg(i18n("You throw the spiderman %s", from), "info")
    if is_thrown[from] then
        removeRopes({ ropes_named["rope_" .. from] })
        removeItems({ items_named["item_" .. from] })
        is_thrown[from] = nil
    else
        is_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
        local attach = SpawnItem(spidermanConfig.items.righthand.model, { coords = coords, entityFixed = true, invisible = true, itemname = "item_" .. from })
        SpawnRopeAndAttach(items_named[spidermanConfig.items[from].itemname], attach, {useCoords = true, ropename = "rope_" .. from})
    end
end

function spidermanThrowTo_mission(from, coords, entity)
end

function spidermanThrowTo_ped(from, coords, entity)
end

function spidermanThrowTo_vehicle(from, coords, entity)
end

function spidermanThrowTo_object(from, coords, entity)
end


function spidermanInit()
    local ped = PlayerPedId()

    -- Spawn items and ropes
    local righthand = SpawnItemAndAttach(spidermanConfig.items.righthand.model, ped, spidermanConfig.items.righthand)
    local lefthand = SpawnItemAndAttach(spidermanConfig.items.lefthand.model, ped, spidermanConfig.items.lefthand)
    local raygun1 = SpawnItemAndAttach(spidermanConfig.items.raygun1.model, ped, spidermanConfig.items.raygun1)
    local raygun2 = SpawnItemAndAttach(spidermanConfig.items.raygun2.model, ped, spidermanConfig.items.raygun2)
end

function spidermanThread()
    DisableControls(spidermanConfig.controls)
    local hit, coords, entity, bone = RayCastGamePlayCamera(spidermanConfig.distance)
    if hit ~= 0 then
        ShowCrosshair(spidermanConfig.crosshair, true)
        if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) then
            local from = IsDisabledControlJustPressed(0, 24) and "lefthand" or "righthand"
            local entity_type = GetEntityType(entity)
            _G["spidermanThrowTo_" .. entity_type](from, coords, entity, entity_type)
        end

        if is_thrown.lefthand or is_thrown.righthand then
            for hand, data in pairs(is_thrown) do
                pullEntity(PlayerPedId(), items_named["item_" .. hand], { step = 2.0, secure = 2.0 })
            end
        end
    else
        ShowCrosshair(spidermanConfig.crosshair)
    end
end
