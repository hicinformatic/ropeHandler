-- Supprimer l'objet lorsque le joueur quitte ou lorsque le script est arrêté
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        RopeHandlerStop()
    end
end)

-- Optionnel : Supprimer l'objet lorsque le joueur quitte le serveur
AddEventHandler('playerDropped', function()
    RopeHandlerStop()
end)
