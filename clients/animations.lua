-- Fonction pour jouer une animation
function PlayAnimation(ped, animation, config)
    logger("Playing animation: " .. animation.name, "debug")

    -- Charger le dictionnaire d'animation
    RequestAnimDict(animation.dict)
    while not HasAnimDictLoaded(animation.dict) do
        Wait(10) -- Attendre jusqu'à ce que le dictionnaire soit chargé
    end

    local duration = (config and config.duration) or animation.duration

    -- Jouer l'animation
    TaskPlayAnim(
        ped, -- Le ped qui exécute l'animation
        (config and config.dict) or animation.dict, -- Le dictionnaire d'animation
        (config and config.name) or animation.name, -- Le nom de l'animation
        (config and config.speedin) or animation.speedin or 8.0, -- Blend in speed
        (config and config.speedout) or animation.speedout or -8.0, -- Blend out speed
        duration or 0, -- Durée (0 = infini)
        (config and config.flags) or animation.flags or 0, -- Flags (1 = boucle, 0 = ne pas répéter)
        (config and config.speed) or animation.speed or 0.0, -- Jouer à cette vitesse
        (config and config.lockx) or animation.lockx or false, -- LockX
        (config and config.locky) or animation.locky or false, -- LockY
        (config and config.lockz) or animation.lockz or false -- LockZ
    )

    if (config and config.wait) or (animation.wait) then
        Wait(duration)
    end

    -- Optionnel : Libérer la mémoire du dictionnaire après utilisation
    RemoveAnimDict(animDict)
end
