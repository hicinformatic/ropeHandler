local rope_size = bungeejumpingConfig.ropedefault or 10.0

function bungeejumpingSetlength()
    if is_unique_thrown and is_unique_thrown.rope then
        logmsg("setlength: " .. rope_size)
        RopeSetUpdateOrder(is_unique_thrown.rope, true)
        RopeForceLength(is_unique_thrown.rope, rope_size)
        RopeResetLength(is_unique_thrown.rope, rope_size)
    end
end

function bungeejumpingClean()
    removeRopes({ ropes_named["rope_bungeejumping"] })
    removeItems({ items_named["item_bungeejumping"] })
    is_unique_thrown = nil
end

function bungeejumpingPrepare(coords, entity)
    if is_unique_thrown and (is_unique_thrown.attach or is_unique_thrown.rope) then
        bungeejumpingClean()
    end
    removeRopes({ ropes_named[bungeejumpingConfig.items.hook.ropename] })
    removeItems({ items_named[bungeejumpingConfig.items.hook.itemname] })
    is_unique_thrown = {}
    is_unique_thrown.attach = SpawnItem(bungeejumpingConfig.items.rightfoot.model, entity, {
        coords = coords,
        itemFixed = true,
        invisible = true,
        itemname = "item_bungeejumping"
    })
    is_unique_thrown.rope = SpawnRopeAndAttach(items_named[bungeejumpingConfig.items.rightfoot.itemname], is_unique_thrown.attach, {
        maxLength = rope_size,
        initLength = rope_size,
        minLength = 0.0,
        ropename = "rope_bungeejumping"
    })
    RopeSetUpdateOrder(is_unique_thrown.rope, true)
    RopeForceLength(is_unique_thrown.rope, 10.0) -- Longueur exacte de la corde
    RopeResetLength(is_unique_thrown.rope, 10.0) -- Réinitialise la longueur pour éviter les bugs
end

function bungeejumpingEquipment()
    local hook = SpawnItemAndAttach(bungeejumpingConfig.items.hook.model, PlayerPedId(), bungeejumpingConfig.items.hook)
    SpawnRopeAndAttach(
        items_named[bungeejumpingConfig.items.righthand.itemname],
        items_named[bungeejumpingConfig.items.rightfoot.itemname],
        bungeejumpingConfig.items.hook)
end

function bungeejumpingInit()
    local ped = PlayerPedId()
    PlayAnimation(ped, bungeejumpingConfig.animations.unthrow)
    local righthand = SpawnItemAndAttach(bungeejumpingConfig.items.righthand.model, ped, bungeejumpingConfig.items.righthand)
    local rightfoot = SpawnItemAndAttach(bungeejumpingConfig.items.rightfoot.model, ped, bungeejumpingConfig.items.rightfoot)
    bungeejumpingEquipment()
end

function bungeejumpingDrawsize(method, size)
    if method == "add" then
        rope_size = rope_size + 1
    elseif method == "sub" then
        rope_size = rope_size - 1
    end
    SetTextFont(0) -- Police
    SetTextProportional(1)
    SetTextScale(0.2, 0.2)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextCentre(1)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(i18n("Rope size: %d", rope_size))
    EndTextCommandDisplayText(0.5, 0.52)
end

function bungeejumpingThread()
    disableControls(bungeejumpingConfig.controls)
    local hit, coords, entity = RayCastGamePlayCamera(measureConfig.distance)
    ShowCrosshair(bungeejumpingConfig.crosshair, hit ~= 0)
    bungeejumpingDrawsize()
    if hit ~= 0 and IsDisabledControlJustPressed(0, 24) then
        TurnPedToTarget(PlayerPedId(), coords)
        if getEntityTypeFormat(entity) == "coords" then
            bungeejumpingPrepare(coords, entity)
        else
            logmsg(i18n("You can't attach a rope to this entity"))
        end
        Citizen.Wait(10)
    elseif IsDisabledControlJustPressed(0, 25) then
        bungeejumpingClean()
        bungeejumpingEquipment()
        Citizen.Wait(10)
    elseif IsDisabledControlJustPressed(0, 96) or IsDisabledControlJustPressed(0, 97) then
        local method = IsDisabledControlJustPressed(0, 96) and "add" or "sub"
        bungeejumpingDrawsize(method)
        bungeejumpingSetlength()
    end
end
