-- Callback pour gérer les options sélectionnées
RegisterNUICallback("selectOption", function(data, cb)
    logger(i18n("Option selected : " .. data.option), "debug")
    closeInit()
    RopeHandlerStart(data.option)
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
        spiderman = i18n("Spiderman"),
        user = i18n("User interface"),
        clean = i18n("Clean"),
        close = i18n("Close"),
        help = i18n("Help"),
    }

    ropes = {}
    for k, v in pairs(Config.Ropes) do
        ropes[k] = {
            name = v,
            lang = optslang[v],
        }
    end

    commands = {}
    for k, v in pairs(Config.Commands) do
        commands[k] = {
            name = v,
            lang = optslang[v],
        }
    end

    chatmsg("UI initialized", "debug")
    chatmsg(Config.Commands, "debug")
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openui",
        ropes = ropes,
        commands = commands,
        active = current_usage.mode,
        lang = Config.DefaultLang,
    })
end
