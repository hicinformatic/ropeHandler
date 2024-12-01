-- Callback pour gérer les options sélectionnées
RegisterNUICallback("selectOption", function(data, cb)
    print("Option sélectionnée : " .. data.option)
    closeInit()
    ropeHandlerStart(data.option)
    cb("ok")
end)

function cleanInit()
    RopeHandlerStop()
end

function closeInit()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeui" })
end

function uiInit()
    optslang = {
        grapplinghook = i18n("Grapplinghook"),
        lasso = i18n("Lasso"),
        user = i18n("User interface"),
        clean = i18n("Clean"),
        close = i18n("Close"),
        help = i18n("Help"),
    }

    options = {}
    for k, v in pairs(Config.Commands) do
        options[k] = {
            name = v,
            lang = optslang[v],
        }
    end

    message("UI initialized", "debug")
    message(Config.Commands, "debug")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openui",
        options = options,
        active = rope_mode,
        lang = Config.DefaultLang,
    })
end
