

local function grapplinghookThrow(coords, entity)
    removeItems({"grappling", "rope"})
    removeRopes({"ropel2r", "roper2g"})
    entity_attached = entity
    if IsEntityAVehicle(entity) then
        AttachPlayerToMovingCar(PlayerPedId(), entity_attached)
        --is_rope_throwed_item = SpawnItemAtVehicle(entity, Config.GrapplingHook.items.grappling)
        entity_type = "vehicle"
    elseif IsEntityAPed(entity) then
        is_rope_throwed_item = SpawnItemAtBone(entity, 18116, Config.GrapplingHook.items.grappling)
        entity_type = "ped"
    elseif IsEntityAnObject(entity) then
        is_rope_throwed_item = SpawnItemAtCoords(coords, Config.GrapplingHook.items.grappling)
        entity_type = "object"
    else
        is_rope_throwed_item = SpawnItemAtCoords(coords, Config.GrapplingHook.items.grappling)
        entity_type = "coords"
    end
    -- is_rope_throwed = SpawnRopeFromTo(items["pelvis"], is_rope_throwed_item)
    chatmsg("Vous avez lancé le grappin sur un: " .. entity_type, "info")
end

function pullPlayerToGrapplingHook(coords)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - coords)

    while distance > 1.0 do
        Citizen.Wait(0)
        playerCoords = GetEntityCoords(playerPed)
        distance = #(playerCoords - coords)

        -- Calculer la direction et la force de traction
        local direction = (coords - playerCoords) / distance
        local force = 1.0 -- Ajustez la force selon vos besoins

        -- Appliquer la force au personnage
        ApplyForceToEntity(playerPed, 1, direction.x * force, direction.y * force, direction.z * force, 0, 0, 0, 0, false, true, true, false, true)
    end
end

function grapplinghookStart()
    local playerPed = PlayerPedId()  -- Récupérer l'identifiant du joueur
    logger("Player ped freezed: " .. playerPed, "debug")
    FreezeEntityPosition(playerPed, true) -- Geler la position du joueur
    local playerPos = GetEntityCoords(playerPed)  -- Récupérer la position du joueur

    -- Vérifier si le joueur a déjà un crochet et/ou une corde attaché
    if next(items) ~= nil then
        RopeHandlerStop()
        chatmsg("Vous rangez votre grappin", "info")
        logger("Items removed", "debug")
    else
        loadItems(playerPed, playerPos, Config.GrapplingHook.items, Config.GrapplingHook.orders) -- Charger les objets
        loadRopes(playerPed, playerPos, Config.GrapplingHook.ropes)  -- Charger les cordes
        PlayAnimation(playerPed, Config.GrapplingHook.animations.unthrow, 1000)
        chatmsg("Vous sortez votre grappin", "info")
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
    if IsControlPressed(0, 25) and not is_rope_throwed then
        local hit, coords, entity = RayCastGamePlayCamera(Config.GrapplingHook.distance)
        if hit ~= 0 then
            ShowCrosshair(true)
            DrawLineToTarget(coords)  -- Dessiner la ligne vers la cible

            if IsDisabledControlJustPressed(0, 24) then
                chatmsg("Vous lancez le grappin", "info")
                PlayAnimation(PlayerPedId(), Config.GrapplingHook.animations.throw, 1000)
                Wait(Config.GrapplingHook.animations.throw.wait)
                grapplinghookThrow(coords, entity)
            end
        else
            ShowCrosshair()
        end
    elseif is_rope_throwed then
        if IsDisabledControlJustPressed(0, 24) then
            PlayAnimation(PlayerPedId(), Config.GrapplingHook.animations.unthrow, 1000)
            chatmsg("Vous récupérez le grappin", "info")
            RopeHandlerRestart()
        elseif entity_type == "vehicle" then
            logger("Attach player to moving car", "debug")
        elseif IsDisabledControlJustPressed(0, 96) then
            chatmsg("Vous rapprochez le grappin", "info")
            if entity_type == "ped" then
                pullRope(entity_attached, PlayerPedId(), 10.0, is_rope_throwed)
            else
                pullRope(PlayerPedId(), is_rope_throwed_item, 10.0, is_rope_throwed)
            end
        elseif IsDisabledControlJustPressed(0, 97) then
            chatmsg("Vous éloignez le grappin", "info")
            if entity_type == "ped" then
                pushRope(entity_attached, PlayerPedId(), 10.0, is_rope_throwed)
            else
                pushRope(PlayerPedId(), is_rope_throwed_item, 10.0, is_rope_throwed)
            end
        end
    end
end
