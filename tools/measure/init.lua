function measureInit()
    local ped = PlayerPedId()
    addWeaponTo(ped, measureConfig.items.scanner.model, measureConfig.items.measure)
end

function measureThread()
    disableControls(measureConfig.controls)
    local hit, coords, entity = RayCastGamePlayCamera(measureConfig.distance)
    ShowCrosshair(measureConfig.crosshair, hit ~= 0)
    if hit ~= 0 and IsDisabledControlJustPressed(0, 24) then
        is_unique_thrown = is_unique_thrown or true
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true)
        logmsg(i18n("Distance measured: %s", distance), "info")
        TurnPedToTarget(PlayerPedId(), coords)
    end
end
