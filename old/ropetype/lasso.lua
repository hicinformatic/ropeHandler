local function lassoThrow()

end

function lassoStart()
    local playerPed = PlayerPedId()  -- Récupérer l'identifiant du joueur
    logger("Player ped freezed: " .. playerPed, "debug")
    FreezeEntityPosition(playerPed, true) -- Geler la position du joueur
    local playerPos = GetEntityCoords(playerPed)  -- Récupérer la position du joueur

    -- Vérifier si le joueur a déjà un crochet et/ou une corde attaché
    if next(items) ~= nil then
        RopeHandlerStop()
        message("Vous rangez votre lasso", "info")
        logger("Items removed", "debug")
    else
        loadItems(playerPed, playerPos, Config.Lasso.items, Config.Lasso.orders) -- Charger les objets
        loadRopes(playerPed, playerPos, Config.Lasso.ropes)  -- Charger les cordes
        message("Vous sortez votre lasso", "info")
        logger("Items loaded", "debug")
    end

    logger("Player ped unfreezed: " .. playerPed, "debug")
    FreezeEntityPosition(playerPed, false)  -- Débloquer la position du joueur
end

function lassoThread()
    DisableControlAction(0, 24, true) -- 24 est l'ID pour l'attaque avec clic gauche
    DisableControlAction(0, 257, true) -- 257 est l'attaque en vue à la première personn

    -- Vérifie si le clic droit est maintenu
    if IsControlPressed(0, 25) then
        local hit, coords, entity = RayCastGamePlayCamera(Config.Lasso.distance)

        if hit ~= 0 then
            logger("Hit: " .. entity .. " at " .. coords.x .. ", " .. coords.y .. ", " .. coords.z, "debug")
            ShowCrosshair(true)
            DrawLineToTarget(coords)  -- Dessiner la ligne vers la cible

            if IsDisabledControlJustPressed(0, 24) then
                message("Vous lancez le grappin", "info")
                PlayAnimation(PlayerPedId(), Config.Lasso.animations.throw, 1000)
                lassoThrow(coords)
            end

        else
            ShowCrosshair()
        end
    end
end
