-- Fonction pour tirer le personnage vers le grappin
function pullEntity(from, to, config)
    local fromPos = GetEntityCoords(from)
    local toPos = GetEntityCoords(to)
    local distance = #(fromPos - toPos)
    if distance < 1.0 then return end
    if config.secure then
        local secureDistance = config.secure*config.step
        if distance < secureDistance then
            return
        end
    end
    -- Calculer la direction et la force de traction
    local direction = (toPos - fromPos) / distance
    local force = config.step or 0.1 -- Ajustez la force selon vos besoins
    -- Appliquer la force au personnage
    ApplyForceToEntity(from, 1, direction.x * force, direction.y * force, direction.z * force, 0, 0, 0, 0, false, true, true, false, true)
    if config.rope then
        -- Mettre à jour la longueur de la corde
        SetRopeLength(config.rope, distance)
    end
end

-- Fonction pour pousser le personnage loin du grappin
function pushEntity(from, to, config)
    local fromPos = GetEntityCoords(from)
    local toPos = GetEntityCoords(to)
    local distance = #(fromPos - toPos)
    -- Calculer la direction et la force de traction
    if distance < 1.0 then return end
    if config.secure then
        local secureDistance = config.secure*config.step
        if distance < secureDistance then
            return
        end
    end
    local direction = (fromPos - toPos) / distance
    local force = config.step or 0.1 -- Ajustez la force selon vos besoins
    -- Appliquer la force au personnage
    ApplyForceToEntity(from, 1, direction.x * force, direction.y * force, direction.z * force, 0, 0, 0, 0, false, true, true, false, true)
    if config.rope then
        -- Mettre à jour la longueur de la corde
        SetRopeLength(config.rope, distance)
    end
end

function pullEntityWithCoords(from, to, config)
    local fromPos = GetEntityCoords(from)
    local toPos = GetEntityCoords(to)
    local distance = #(fromPos - toPos)
    if distance < 1.0 then return end
    -- Calculer la direction et la force de traction
    local direction = (toPos - fromPos) / distance
    local force = config.step or 0.1 -- Ajustez la force selon vos besoins
    -- Appliquer la force au personnage
    ApplyForceToEntity(from, 1, direction.x * force, direction.y * force, direction.z * force, 0, 0, 0, 0, false, true, true, false, true)
    --if config.rope then
    --    -- Mettre à jour la longueur de la corde
    --    SetRopeLength(config.rope, distance)
    --end
end
