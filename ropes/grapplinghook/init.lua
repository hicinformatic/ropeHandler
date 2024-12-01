function grapplinghookInit()
    rope_mode = "grapplinghook"
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)

    PlayAnimation(ped, grapplinghookConfig.animations.unthrow, 1000)
    -- Spawn items and ropes
    logger(i18n("add item righthand"), "debug")
    local righthand = SpawnItemAndAttach(grapplinghookConfig.items.righthand.model, ped, grapplinghookConfig.items.righthand)
    logger(i18n("add item lefthand"), "debug")
    local lefthand = SpawnItemAndAttach(grapplinghookConfig.items.lefthand.model, ped, grapplinghookConfig.items.lefthand)
    logger(i18n("add item rope"), "debug")
    local ropeitem = SpawnItemAndAttach(grapplinghookConfig.items.rope.model, ped, grapplinghookConfig.items.rope)
    logger(i18n("generate rope left to right hand"), "debug")
    SpawnRopeAndAttach(righthand, lefthand, grapplinghookConfig.items.rope)
    logger(i18n("add item grapplinghook"), "debug")
    local grapplinghook = SpawnItem(grapplinghookConfig.items.grapplinghook.model, grapplinghookConfig.items.grapplinghook)
    logger(i18n("attach item grapplinghook"), "debug")
    SpawnRopeAndAttach(righthand, grapplinghook, grapplinghookConfig.items.grapplinghook)

    FreezeEntityPosition(ped, false)
    local playerPos = GetEntityCoords(playerPed)
end

function grapplinghookThread()
    DisableControlAction(0, 24, true) -- 24 est l'ID pour l'attaque avec clic gauche
    DisableControlAction(0, 257, true) -- 257 est l'attaque en vue à la première personn
    DisableControlAction(0, 96, true) -- Désactiver la touche "-" (code 44)
    DisableControlAction(0, 97, true) -- Désactiver la touche "+" (code 45)

    -- Vérifie si le clic droit est maintenu
    if IsControlPressed(0, 25) and not is_rope_throwed then
        local hit, coords, entity = RayCastGamePlayCamera(Config.GrapplingHook.distance)
        if hit ~= 0 then
            ShowCrosshair(true)
            DrawLineToTarget(coords)  -- Dessiner la ligne vers la cible

            if IsDisabledControlJustPressed(0, 24) then
                message("Vous lancez le grappin", "info")
                PlayAnimation(PlayerPedId(), grapplinghookConfig.animations.throw, 1000)
                Wait(grapplinghookConfig.animations.throw.wait)
                grapplinghookThrow(coords, entity)
            end
        else
            ShowCrosshair()
        end
    elseif is_rope_throwed then
        if IsDisabledControlJustPressed(0, 24) then
            PlayAnimation(PlayerPedId(), grapplinghookConfig.animations.unthrow, 1000)
            message("Vous récupérez le grappin", "info")
            RopeHandlerRestart()
        elseif entity_type == "vehicle" then
            logger("Attach player to moving car", "debug")
        elseif IsDisabledControlJustPressed(0, 96) then
            message("Vous rapprochez le grappin", "info")
            if entity_type == "ped" then
                pullRope(entity_attached, PlayerPedId(), 10.0, is_rope_throwed)
            else
                pullRope(PlayerPedId(), is_rope_throwed_item, 10.0, is_rope_throwed)
            end
        elseif IsDisabledControlJustPressed(0, 97) then
            message("Vous éloignez le grappin", "info")
            if entity_type == "ped" then
                pushRope(entity_attached, PlayerPedId(), 10.0, is_rope_throwed)
            else
                pushRope(PlayerPedId(), is_rope_throwed_item, 10.0, is_rope_throwed)
            end
        end
    end
end
