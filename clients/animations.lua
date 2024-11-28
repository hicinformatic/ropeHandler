-- Fonction pour jouer une animation
function PlayAnimation(ped, animation, duration)
    logger("Playing animation: " .. animation.name, "debug")

    -- Charger le dictionnaire d'animation
    RequestAnimDict(animation.dict)
    while not HasAnimDictLoaded(animation.dict) do
        Wait(10) -- Attendre jusqu'à ce que le dictionnaire soit chargé
    end

    -- Jouer l'animation
    TaskPlayAnim(
        ped, -- Le ped qui exécute l'animation
        animation.dict, -- Le dictionnaire d'animation
        animation.name, -- Le nom de l'animation
        animation.speedin or 8.0, -- Blend in speed
        animation.speedout or -8.0, -- Blend out speed
        duration, -- Durée (0 = infini)
        animation.flags, -- Flags (1 = boucle, 0 = ne pas répéter)
        animation.speed or 0.0, -- Jouer à cette vitesse
        animation.lockx or false, -- LockX
        animation.locky or false, -- LockY
        animation.lockz or false -- LockZ
    )

    -- Optionnel : Libérer la mémoire du dictionnaire après utilisation
    RemoveAnimDict(animDict)
end
