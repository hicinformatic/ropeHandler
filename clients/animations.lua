-- Fonction pour jouer une animation
function PlayAnimation(ped, animation, cfg)
    logger("Playing animation: " .. animation.name, "debug")

    -- Charger le dictionnaire d'animation
    RequestAnimDict(animation.dict)
    while not HasAnimDictLoaded(animation.dict) do
        Wait(10) -- Attendre jusqu'à ce que le dictionnaire soit chargé
    end

    local duration = (cfg and cfg.duration) or animation.duration

    -- Jouer l'animation
    TaskPlayAnim(
        ped, -- Le ped qui exécute l'animation
        (cfg and cfg.dict) or animation.dict, -- Le dictionnaire d'animation
        (cfg and cfg.name) or animation.name, -- Le nom de l'animation
        (cfg and cfg.speedin) or animation.speedin or 8.0, -- Blend in speed
        (cfg and cfg.speedout) or animation.speedout or -8.0, -- Blend out speed
        duration or 0, -- Durée (0 = infini)
        (cfg and cfg.flags) or animation.flags or 0, -- Flags (1 = boucle, 0 = ne pas répéter)
        (cfg and cfg.speed) or animation.speed or 0.0, -- Jouer à cette vitesse
        (cfg and cfg.lockx) or animation.lockx or false, -- LockX
        (cfg and cfg.locky) or animation.locky or false, -- LockY
        (cfg and cfg.lockz) or animation.lockz or false -- LockZ
    )

    if (cfg and cfg.wait) or (animation.wait) then
        Wait(duration)
    end

    -- Optionnel : Libérer la mémoire du dictionnaire après utilisation
    RemoveAnimDict(animDict)
end
