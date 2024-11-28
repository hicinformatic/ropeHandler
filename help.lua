function logger(message, level)
    if level == "debug" and not Config.Debug then
        return
    end

    -- Définir les couleurs pour chaque niveau de log
    local colorTags = {
        debug = "^8", -- Gris
        success = "^2", -- Vert
        info = "^4", -- Bleu
        warning = "^3", -- Jaune
        error = "^1", -- Rouge
        default = "^7" -- Blanc (par défaut)
    }

    -- Obtenir la balise de couleur pour le niveau spécifié
    local color = colorTags[level] or colorTags.default

    -- Ajouter le message avec la balise de couleur
    if level ~= nil then
        print(color .. "[ROPEHOOK](" .. level:upper() .. "): " .. message .. colorTags.default)
    else
        print(colorTags.default .. "[ROPEHOOK]: " .. message .. colorTags.default)
    end
end

function message(message, level)
    if level == "debug" and not Config.Debug then
        return
    end
    if level == nil then
        level = "info"
    end
    TriggerEvent('chat:addMessage', {
        color = Config.Colors[level],
        multiline = true,
        args = {"[ROPEHOOK]", message}
    })
end

-- Fonction pour vérifier si un string est dans un tableau
function isStringInArray(array, str)
    for _, value in ipairs(array) do
        if value == str then
            return true
        end
    end
    return false
end
