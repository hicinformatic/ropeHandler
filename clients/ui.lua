-- Callback pour gérer les options sélectionnées
RegisterNUICallback("selectOption", function(data, cb)
    closeInit()
    RopeHandlerStart(data.option, data.skin, data.invincible)
    cb("ok")
end)

function cleanInit()
    if load_skin then
        loadSkinPed(PlayerPedId(), base_skin)
        load_skin = false
    end
    RopeHandlerStop()
end

function closeInit()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeui" })
end

function uiInit()
    ropes = {}
    for k, v in pairs(Config.Ropes) do
        ropes[k] = { name = v.name, lang = i18n(v.lang), skin = v.skin, }
    end

    commands = {}
    for k, v in pairs(Config.Commands) do
        commands[k] = { name = v.name, lang = i18n(v.lang), }
    end

    local active = current_usage
    if load_skin and active then
        active = active .. "_skin"
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openui",
        ropes = ropes,
        commands = commands,
        active = active,
        invincible = invincible,
        invincibleLang = i18n("Enable invincibility"),
        withSkin = i18n("With skin"),
        choiceOption = i18n("Choice an option"),
        lang = Config.DefaultLang,
    })
end
