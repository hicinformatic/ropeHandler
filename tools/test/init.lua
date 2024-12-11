function testInit()
    local ped = PlayerPedId()
    addWeaponTo(ped, testConfig.items.scanner.model, testConfig.items.scanner)
end

function testThread()
    disableControls(testConfig.controls)
    local hit, coords, entity = RayCastGamePlayCamera(testConfig.distance)
    ShowCrosshair(testConfig.crosshair, hit ~= 0)
    if hit ~= 0 and IsDisabledControlJustPressed(0, 24) then
        local ped = PlayerPedId()
        TurnPedToTarget(ped, coords)
        is_unique_thrown = is_unique_thrown or true
        local pedCoords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(pedCoords, coords, true)
        logmsg(i18n("Target coordinates: %s", coords), "info")
        logmsg(i18n("Player coordinates: %s", pedCoords), "info")
        logmsg(i18n("Distance measured: %s", distance), "info")
    end
end
