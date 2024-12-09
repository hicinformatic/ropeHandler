bungeejumpingConfig = {
    distance = 50.0,
    ropedefault = 10.0,
    controls = {
        37, -- tab
        24, -- leftClick
        257, -- leftClick
        25, -- rightClick
        96, -- scrollUp
        97, -- scrollDown
        22, -- space
    }
}

bungeejumpingConfig.steps = {
    object = {step = 10.0, secure = 2.0},
    ped = {step = 10.0, secure = 2.0},
    vehicle = {step = 10.0, secure = 2.0},
    coords = {step = 10.0, secure = 2.0},
}

bungeejumpingConfig.items = {
    hook = {
        model = "xm3_prop_xm3_hook_01a",
        bonePed = "SKEL_R_Hand",
        offset = vector3(0.15, 0.0, 0.02),
        rotation = vector3(0.0, -50.0, 180.0),
        --maxLength = 1.5,
        noCollision = true,
        itemname = "item_hook",
        ropename = "rope_hook",
    },
    righthand = {
        model = "prop_golf_ball",
        bonePed = "SKEL_R_Hand",
        offset = vector3(0.1, 0.01, 0.0),
        invisible = true,
        itemname = "bjrighthand",
    },
    rightfoot = {
        model = "prop_golf_ball",
        bonePed = "SKEL_R_Foot",
        invisible = true,
        itemname = "bjrightfoot",
    },
}

bungeejumpingConfig.crosshair = {
    showLine = true,
    colorLine = { 255, 0, 0, 255 },
    crosshairDict = "helicopterhud",
    crosshaireName = "hud_dest",
    colorOff = {128, 128, 128, 125},
    colorOn = {255, 255, 255, 255},
}

bungeejumpingConfig.animations = {
    throw = {
        dict = "weapons@projectile@",
        name = "throw_m_fb_stand",
        duration = 450,
        wait = true,
    },
    unthrow = {
        dict = "weapons@projectile@",
        name = "static_drop",
        duration = 500,
        wait = true,
    },
}
