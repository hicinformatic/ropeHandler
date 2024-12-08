weapons_loaded = {}
weapons_named = {}

function addWeaponTo(to, weapon, cfg)
    local weaponHash = GetHashKey(weapon)
    GiveWeaponToPed(
        to,
        weaponHash,
        getCfg(cfg, "ammo", 1),
        getCfg(cfg, "isHidden", false),
        getCfg(cfg, "forceInHand", true)
    )
    table.insert(weapons_loaded, {to = to, weapon = weapon})
end

function RemoveWeaponTo(to, weapon)
    local weaponHash = GetHashKey(weapon)
    RemoveWeaponFromPed(to, weaponHash)
end

function removeWeapons(weapons)
    for k, v in pairs(weapons) do
        RemoveWeaponTo(v.to, v.weapon)
    end
end
