function ShowCrosshair(accessible)
    -- Afficher le réticule de visée
    -- Dictionnaire de textures et icône à afficher
    local textureDict = Config.CrosshairDict -- Exemple de dictionnaire d'icônes
    local textureName = Config.CrosshaireName -- Exemple d'icône à afficher

    -- Charger la texture si nécessaire
    if not HasStreamedTextureDictLoaded(textureDict) then
        RequestStreamedTextureDict(textureDict, true)
        while not HasStreamedTextureDictLoaded(textureDict) do
            Citizen.Wait(0)
        end
    end

    -- Coordonnées pour centrer l'icône à l'écran
    local x = 0.5  -- Centre horizontal (50% de la largeur de l'écran)
    local y = 0.5  -- Centre vertical (50% de la hauteur de l'écran)
    local width = 0.03  -- Largeur de l'icône (5% de la largeur de l'écran)
    local height = 0.05  -- Hauteur de l'icône (5% de la hauteur de l'écran)
    local rotation = 0.0  -- Pas de rotation pour l'icône

    -- Dessiner l'icône au centre de l'écran
    if accessible then
        -- L'objet est accessible, afficher l'icône verte
        DrawSprite(textureDict, textureName, x, y, width, height, rotation,
            Config.CrosshairColorOn[1], Config.CrosshairColorOn[2], Config.CrosshairColorOn[3], Config.CrosshairColorOn[4])  -- Couleur verte (255,0,0)
    else
        -- L'objet n'est pas accessible, afficher l'icône rouge
        DrawSprite(textureDict, textureName, x, y, width, height, rotation,
            Config.CrosshairColorOff[1], Config.CrosshairColorOff[2], Config.CrosshairColorOff[3], Config.CrosshairColorOff[4])  -- Couleur rouge (255,0,0)
    end
end

-- Fonction pour dessiner une ligne du péd à la cible
function DrawLineToTarget(targetCoords)
    local ped = PlayerPedId()  -- Récupérer l'ID du joueur
    local pedCoords = GetEntityCoords(ped)  -- Récupérer les coordonnées du joueur
    -- Dessiner une ligne entre les deux points (péd et cible)
    DrawLine(pedCoords, targetCoords, Config.ColorLine[1], Config.ColorLine[2], Config.ColorLine[3], Config.ColorLine[4])
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
    local a, b, c, d, e = GetShapeTestResult(
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
    return b, c, e
end
