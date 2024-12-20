function ShowCrosshair(cfg, accessible)
    -- Default cfguration
    if not cfg then
        cfg = {
            crosshairDict = "helicopterhud",
            crosshaireName = "hud_dest",
            crosshairColorOff = {128, 128, 128, 125},
            crosshairColorOn = {255, 255, 255, 255},
        }
    end
    -- Get the texture dictionary and texture name
    local textureDict = cfg.crosshairDict -- Exemple de dictionnaire d'icônes
    local textureName = cfg.crosshaireName -- Exemple d'icône à afficher
    -- Load the texture if necessary
    if not HasStreamedTextureDictLoaded(textureDict) then
        RequestStreamedTextureDict(textureDict, true)
        while not HasStreamedTextureDictLoaded(textureDict) do
            Citizen.Wait(0)
        end
    end
    -- Coordinates and size of the icon
    local x = (cfg and cfg.x) or 0.5  -- Center horizontal (50% of the screen width)
    local y = (cfg and cfg.y) or 0.5  -- Center vertical (50% of the screen height)
    local width = (cfg and cfg.width) or 0.008  -- Width of the icon (3% of the screen width)
    local height = (cfg and cfg.height) or 0.014  -- Height of the icon (5% of the screen height)
    local rotation = (cfg and cfg.rotation) or 0.0  -- Rotation of the icon (0 degrees)

    -- Dessiner l'icône au centre de l'écran
    if accessible then
        -- L'objet est accessible, afficher l'icône verte
        DrawSprite(
            textureDict,
            textureName,
            x,
            y,
            width,
            height,
            rotation,
            cfg.colorOn[1],
            cfg.colorOn[2],
            cfg.colorOn[3],
            cfg.colorOn[4]
        )
    else
        -- L'objet n'est pas accessible, afficher l'icône rouge
        DrawSprite(
            textureDict,
            textureName,
            x,
            y,
            width,
            height,
            rotation,
            cfg.colorOff[1],
            cfg.colorOff[2],
            cfg.colorOff[3],
            cfg.colorOff[4]
        )  -- Couleur rouge (255,0,0)
    end
end

-- Fonction pour dessiner une ligne du péd à la cible
function DrawLineToTarget(targetCoords, color)
    color = color or { 255, 0, 0, 255 }  -- Couleur par défaut : rouge
    local ped = PlayerPedId()  -- Récupérer l'ID du joueur
    local pedCoords = GetEntityCoords(ped)  -- Récupérer les coordonnées du joueur
    -- Dessiner une ligne entre les deux points (péd et cible)
    DrawLine(pedCoords, targetCoords, color[1],color[2], color[3], color[4])
end

function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local retval, hit, coords, surface, entity = GetShapeTestResult(
        StartShapeTestRay(
            cameraCoord.x,
            cameraCoord.y,
            cameraCoord.z,
            destination.x,
            destination.y,
            destination.z,
            -1,
            PlayerPedId(),
            1
        )
    )
    return hit, coords, entity
end

function TurnPedToTarget(ped)
    -- Check if the ped exists
    if not DoesEntityExist(ped) then return end
    -- Get the camera rotation and ped coordinates
    local cameraRotation = GetGameplayCamRot(2) -- En mode "world space"
    local pedCoords = GetEntityCoords(ped)
    -- Calculate the direction from the camera to the ped
    local heading = cameraRotation.z -- Get the Z rotation of the camera
    -- Apply the new heading to the ped
    SetEntityHeading(ped, heading)
end

function getBoneEntity(coords, entity, boneIndex, step)
    local bonePos = GetWorldPositionOfEntityBone(entity, boneIndex)  -- Obtenir la position du bone
    local distance = GetDistanceBetweenCoords(coords, bonePos, true)  -- Obtenir la distance entre le joueur et le bone
    return distance < step
end

function getPedBoneEntity(coords, entity, cfg)
    if not cfg then cfg = { step = 0.1, stop = 5 } end
    for k, v in pairs(Config.PedBones) do
        local boneIndex = GetPedBoneIndex(entity, v)-- Obtenir l'index du bone par son nom
        if getBoneEntity(coords, entity, boneIndex, cfg.step) then
            return boneIndex, k
        end
    end
    if cfg.step > cfg.stop then return nil end
    cfg.step = cfg.step + 0.1
    return getPedBoneEntity(coords, entity, cfg)
end

function getVehicleBoneEntity(coords, entity, cfg)
    if not cfg then cfg = { step = 0.1, stop = 5 } end
    for k, v in pairs(Config.VehicleBones) do
        local boneIndex = GetEntityBoneIndexByName(entity, v)-- Obtenir l'index du bone par son nom
        if getBoneEntity(coords, entity, boneIndex, cfg.step) then
            return boneIndex, v
        end
    end
    if cfg.step > cfg.stop then return nil end
    cfg.step = cfg.step + 0.1
    return getVehicleBoneEntity(coords, entity, cfg)
end
