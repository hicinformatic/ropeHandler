
-- Supprimer l'objet lorsque le joueur quitte ou lorsque le script est arrêté
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        logger("Resource stopped", "debug")
        message("Resource stopped", "debug")
        RopeHandlerStop()
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        message("Resource started", "debug")
    end
end)

-- Optionnel : Supprimer l'objet lorsque le joueur quitte le serveur
AddEventHandler('playerDropped', function()
    logger("Resource stopped", "debug")
    message("Player dropped", "debug")
    RopeHandlerStop()
end)
