function bungeejumpingInit()
    local ped = PlayerPedId()
    PlayAnimation(ped, bungeejumpingConfig.animations.unthrow)
    local righthand = SpawnItemAndAttach(bungeejumpingConfig.items.righthand.model, ped, bungeejumpingConfig.items.righthand)
    local rightfoot = SpawnItemAndAttach(bungeejumpingConfig.items.rightfoot.model, ped, bungeejumpingConfig.items.rightfoot)
    local hook = SpawnItemAndAttach(bungeejumpingConfig.items.hook.model, ped, bungeejumpingConfig.items.hook)
    SpawnRopeAndAttach(righthand, rightfoot, grapplinghookConfig.items.hook)
end

local number = 0 -- Nombre affiché
local showNumber = false -- Afficher ou non le nombre
--function DrawTextOnScreen(text, x, y, scale, r, g, b, a)
--DrawTextOnScreen("Nombre: " .. number, 0.5, 0.5, 0.7, 255, 255, 255, 255)
function bungeejumpingDrawsize(method, size)
    SetTextFont(0) -- Police
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextCentre(1)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(i18n("Rope size: %s", size))
    EndTextCommandDisplayText(x, y)
end



function bungeejumpingThread()
    disableControls(bungeejumpingConfig.controls)
    local hit, coords, entity = RayCastGamePlayCamera(measureConfig.distance)
    ShowCrosshair(bungeejumpingConfig.crosshair, hit ~= 0)
    bungeejumpingDrawsize("keep", 50)
    if hit ~= 0 and IsDisabledControlJustPressed(0, 24) then
        is_unique_thrown = bungeejumpingConfig.ropedefault or 50.0
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true)
        logmsg(i18n("Distance measured: %s", distance), "info")
        TurnPedToTarget(PlayerPedId(), coords)
    --elseif IsDisabledControlJustPressed(0, 96) or IsDisabledControlJustPressed(0, 97) then
    --    local method = IsDisabledControlJustPressed(0, 96) and "add" or "sub"
    end
end
