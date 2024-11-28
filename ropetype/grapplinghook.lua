local function grapplinghookThrow(coords)
    removeItems({"grappling", "rope"})
    removeRopes({"ropel2r", "roper2g"})
    local throweditem = SpawnItemAtCoords(coords, Config.GrapplingHook.items.grappling)
    isRopeThrowed = SpawnRopeFromTo(items["pelvis"], throweditem)
end

function grapplinghookStart()
    local playerPed = PlayerPedId()  -- Récupérer l'identifiant du joueur
    logger("Player ped freezed: " .. playerPed, "debug")
    FreezeEntityPosition(playerPed, true) -- Geler la position du joueur
    local playerPos = GetEntityCoords(playerPed)  -- Récupérer la position du joueur

    -- Vérifier si le joueur a déjà un crochet et/ou une corde attaché
    if next(items) ~= nil then
        RopeHandlerStop()
        message("Vous rangez votre grappin", "info")
        logger("Items removed", "debug")
    else
        loadItems(playerPed, playerPos, Config.GrapplingHook.items, Config.GrapplingHook.orders) -- Charger les objets
        loadRopes(playerPed, playerPos, Config.GrapplingHook.ropes)  -- Charger les cordes
        PlayAnimation(playerPed, Config.GrapplingHook.animations.unthrow, 1000)
        message("Vous sortez votre grappin", "info")
        logger("Items loaded", "debug")
    end

    logger("Player ped unfreezed: " .. playerPed, "debug")
    FreezeEntityPosition(playerPed, false)  -- Débloquer la position du joueur
end

function grapplinghookThread()
    DisableControlAction(0, 24, true) -- 24 est l'ID pour l'attaque avec clic gauche
    DisableControlAction(0, 257, true) -- 257 est l'attaque en vue à la première personn
    DisableControlAction(0, 96, true) -- Désactiver la touche "-" (code 44)
    DisableControlAction(0, 97, true) -- Désactiver la touche "+" (code 45)

    -- Vérifie si le clic droit est maintenu
    if IsControlPressed(0, 25) and not isRopeThrowed then
        local hit, coords, entity = RayCastGamePlayCamera(Config.GrapplingHook.distance)
        if hit ~= 0 then
            ShowCrosshair(true)
            DrawLineToTarget(coords)  -- Dessiner la ligne vers la cible

            if IsDisabledControlJustPressed(0, 24) then
                message("Vous lancez le grappin", "info")
                PlayAnimation(PlayerPedId(), Config.GrapplingHook.animations.throw, 1000)
                Wait(Config.GrapplingHook.animations.throw.wait)
                grapplinghookThrow(coords)
            end
        else
            ShowCrosshair()
        end
    else
        if IsDisabledControlJustPressed(0, 24) and isRopeThrowed then
            PlayAnimation(PlayerPedId(), Config.GrapplingHook.animations.unthrow, 1000)
            message("Vous récupérez le grappin", "info")
            RopeHandlerRestart()
        elseif IsDisabledControlJustPressed(0, 96) then
            message("Vous rapprochez le grappin", "info")
            decreaseRope(isRopeThrowed)
        elseif IsDisabledControlJustPressed(0, 97) then
            message("Vous éloignez le grappin", "info")
            increaseRope(isRopeThrowed)
        end
    end


end
