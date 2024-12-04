
local is_thrown = {}

function spidermanThrowClean(from)
    removeRopes({ ropes_named["rope_" .. from] })
    removeItems({ items_named["item_" .. from] })
    is_thrown[from] = nil
end

function spidermanThrowSpawn_coords(from, coords, entity, entity_type)
    logmsg(i18n("You throw the spiderman %s", from), "info")
    is_thrown[from] = { coords = coords, entity = entity, entity_type = entity_type }
    local attach = SpawnItem(spidermanConfig.items.righthand.model, { coords = coords, entityFixed = true, invisible = true, itemname = "item_" .. from })
    SpawnRopeAndAttach(items_named[spidermanConfig.items[from].itemname], attach, {ropename = "rope_" .. from})
end
function spidermanThrowSpawn_mission(from, coords, entity) spidermanThrowSpawn_coords(from, coords, entity, "mission") end


function spidermanThrowSpawn_ped(from, coords, entity)
end

function spidermanThrowSpawn_vehicle(from, coords, entity)
end

function spidermanThrowSpawn_object(from, coords, entity)
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
    disableControls(spidermanConfig.controls)
    local hit, coords, entity, bone = RayCastGamePlayCamera(spidermanConfig.distance)
    ShowCrosshair(spidermanConfig.crosshair, hit ~= 0)
    if IsDisabledControlJustPressed(0, 24) or IsDisabledControlJustPressed(0, 25) then
        local from = IsDisabledControlJustPressed(0, 24) and "lefthand" or "righthand"
        if is_thrown[from] then
            spidermanThrowClean(from)
        else
            if hit ~= 0 then
                TurnPedToTarget(PlayerPedId(), coords)
                local entity_type = getEntityTypeFormat(entity)
                _G["spidermanThrowSpawn_" .. entity_type](from, coords, entity, entity_type)
            end
        end
    end
    for hand, data in pairs(is_thrown) do
        pullEntity(PlayerPedId(), items_named["item_" .. hand], { step = 2.0, secure = 2.0 })
    end
end
