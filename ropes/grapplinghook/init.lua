local is_thrown = nil

-- If entity target is coords
function grapplinghookSpawn_coords(coords, entity)
    logmsg(i18n("You throw the grappling hook on coords"), "info")
    is_thrown.attach = SpawnItem(grapplinghookConfig.items.righthand.model, { coords = coords, entityFixed = true, invisible = true })
    SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], is_thrown.attach)
end
function grapplinghookSpawn_mission(coords, entity) grapplinghookSpawn_coords(coords, entity) end

function grapplinghookTo_coords(method)
    _G[method .. "Entity"](PlayerPedId(), is_thrown.attach, { step = 10.0 })
end
function grapphlinghookTo_mission(coords, entity) grapphlinghookTo_coords(coords, entity) end

local function attachObjectToPedHead(ped)
    -- Vérifiez si le ped existe
    if not DoesEntityExist(ped) then
        print("Le ped n'existe pas.")
        return
    end

    -- Charger le modèle de l'objet
    local objectModel = "h4_prop_h4_rope_hook_01a" -- Nom du modèle
    RequestModel(objectModel) -- Demander le modèle

    while not HasModelLoaded(objectModel) do
        Wait(500) -- Attendre jusqu'à ce que le modèle soit chargé
    end

    -- Créer l'objet
    local object = CreateObject(GetHashKey(objectModel), 0, 0, 0, true, true, false)

    -- Obtenir la position de la tête du ped
    local boneIndex = GetPedBoneIndex(ped, config.PedBones["SKEL_Head"]) -- Obtenir l'index de l'os de la tête
    local offset = vector3(0.0, 0.0, 0.1) -- Définir un léger décalage au-dessus de la tête

    -- Attacher l'objet à la tête du ped
    AttachEntityToEntity(object, ped, boneIndex, offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    print("Objet attaché à la tête du ped.")
    table.insert(items_loaded, object)

end

-- If entity target is a ped
function grapplinghookSpawn_ped(coords, entity)
    logmsg(i18n("You throw the grappling hook on a ped"), "info")
    local boneIndex, boneName = getPedBoneEntity(coords, entity)
    attachObjectToPedHead(entity)
    --SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], entity, {toBonePed = boneName})
end

function grapplinghookTo_ped(method)
    logmsg(i18n("You pull the grappling hook"), "info")
    --_G[method .. "Entity"](PlayerPedId(), is_thrown.entity, { step = 10.0 })
end

-- If entity target is a object
function grapplinghookSpawn_object(coords, entity)
    logmsg(i18n("You throw the grappling hook on an object"), "info")
    SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], entity)
end

function grapplinghookTo_object(method)
    logmsg(i18n("You pull the grappling hook"), "info")
    _G[method .. "Entity"](is_thrown.entity, PlayerPedId(), { step = 10.0 })
    local new_coords = GetEntityCoords(is_thrown.entity)
    if new_coords == is_thrown.coords then
        _G[method .. "Entity"](PlayerPedId(), is_thrown.entity, { step = 10.0 })
    else
        is_thrown.coords = new_coords
    end
end

-- If entity target is a vehicle
function grapplinghookSpawn_vehicle(coords, entity)
    logmsg(i18n("You throw the grappling hook on a vehicle"), "info")
    local boneIndex, boneName = getVehicleBoneEntity(coords, entity)
    SpawnRopeAndAttach(items_named[grapplinghookConfig.items.righthand.itemname], entity, {toBoneVehicle = bone})
end

function grapplinghookTo_vehicle(method)
    logmsg(i18n("You pull the grappling hook"), "info")
    --_G[method .. "Entity"](PlayerPedId(), is_thrown.entity, { step = 10.0 })
end

local function grapplinghookThrow(coords, entity, entity_type)
    removeItems({ items_named[grapplinghookConfig.items.grapplinghook.itemname] })
    removeRopes({ ropes_named[grapplinghookConfig.items.grapplinghook.ropename] })
    _G["grapplinghookSpawn_" .. entity_type](coords, entity)
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
    disableControls(grapplinghookConfig.controls)
    if is_thrown then
        --logger("is_thrown", "debug")
        if IsDisabledControlJustPressed(0, 24) then
            logmsg(i18n("You get the grappling hook back"), "info")
            RopeHandlerRestart()
            is_thrown = nil
        elseif IsDisabledControlJustPressed(0, 96) or IsDisabledControlJustPressed(0, 97) then
            local method = IsDisabledControlJustPressed(0, 96) and "pull" or "push"
            _G["grapplinghookTo_" .. is_thrown["entity_type"]](method)
        end
    else
        local hit, coords, entity, bone = RayCastGamePlayCamera(grapplinghookConfig.distance)
        ShowCrosshair(grapplinghookConfig.crosshair, hit ~= 0)
        if hit ~= 0 and IsDisabledControlJustPressed(0, 24) then
            is_thrown = { from = "righthand", coords = coords, entity = entity, entity_type = getEntityTypeFormat(entity) }
            logger(json.encode(is_thrown), "debug")
            TurnPedToTarget(PlayerPedId(), coords)
            PlayAnimation(PlayerPedId(), grapplinghookConfig.animations.throw)
            grapplinghookThrow(coords, entity, is_thrown.entity_type)
        end
    end
end
