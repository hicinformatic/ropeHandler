

prototypeConfig = {
    distance = 150.0,
    controls = {
        37, -- tab
        24, -- leftClick
        257, -- leftClick
        25, -- rightClick
        96, -- scrollUp
        97, -- scrollDown
    }
}

prototypeConfig.steps = {
    object = {step = 10.0, secure = 2.0},
    ped = {step = 10.0, secure = 2.0},
    vehicle = {step = 10.0, secure = 2.0},
    coords = {step = 10.0, secure = 2.0},
}

prototypeConfig.items = {
    raygun1 = {
        model = "m23_1_prop_m31_pi_raygun",
        bonePed = "SKEL_L_Hand",
        offset = vector3(0.17, 0.05, -0.01),
        rotation = vector3(-120.0, 0.0, 0.0),
        noCollision = true,
        itemname = "item_raygun1",
        ropename = "rope_raygun1",
    },
    raygun2 = {
        model = "m23_1_prop_m31_pi_raygun",
        bonePed = "SKEL_R_Hand",
        offset = vector3(0.19, 0.05, 0.01),
        rotation = vector3(-60.0, 0.0, 0.0),
        noCollision = true,
        itemname = "item_raygun1",
        ropename = "rope_raygun1",
    },
    righthand = {
        model = "prop_golf_ball",
        bonePed = "SKEL_R_Hand",
        offset = vector3(0.1, 0.01, 0.0),
        invisible = true,
        itemname = "ghrighthand",
    },
    lefthand = {
        model = "prop_golf_ball",
        bonePed = "SKEL_L_Hand",
        offset = vector3(0.1, -0.01, 0.0),
        invisible = true,
        itemname = "ghlefthand",
    },
    pelvis = {
        model = "prop_golf_ball",
        bonePed = "SKEL_Pelvis",
        itemname = "ghpelvis",
    },
}

prototypeConfig.crosshair = {
    showLine = true,
    colorLine = { 255, 0, 0, 255 },
    crosshairDict = "helicopterhud",
    crosshaireName = "hud_dest",
    colorOff = {128, 128, 128, 125},
    colorOn = {255, 255, 255, 255},
}

prototypeConfig.animations = {
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
