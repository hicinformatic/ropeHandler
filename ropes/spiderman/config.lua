

spidermanConfig = {
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

spidermanConfig.items = {
    raygun1 = {
        model = "m23_1_prop_m31_pi_raygun",
        bone = "SKEL_L_Hand",
        offset = vector3(0.17, 0.05, -0.01),
        rotation = vector3(-120.0, 0.0, 0.0),
        noCollision = true,
        itemname = "item_raygun1",
        ropename = "rope_raygun1",
    },
    raygun2 = {
        model = "m23_1_prop_m31_pi_raygun",
        bone = "SKEL_R_Hand",
        offset = vector3(0.19, 0.05, 0.01),
        rotation = vector3(-60.0, 0.0, 0.0),
        noCollision = true,
        itemname = "item_raygun1",
        ropename = "rope_raygun1",
    },
    righthand = {
        model = "prop_golf_ball",
        bone = "SKEL_R_Hand",
        offset = vector3(0.1, 0.01, 0.0),
        --invisible = true,
        itemname = "ghrighthand",
    },
    lefthand = {
        model = "prop_golf_ball",
        bone = "SKEL_L_Hand",
        offset = vector3(0.1, -0.01, 0.0),
        --invisible = true,
        itemname = "ghlefthand",
    },
    pelvis = {
        model = "prop_golf_ball",
        bone = "SKEL_Pelvis",
        itemname = "ghpelvis",
    },
}

spidermanConfig.crosshair = {
    showLine = true,
    colorLine = { 255, 0, 0, 255 },
    crosshairDict = "helicopterhud",
    crosshaireName = "hud_dest",
    colorOff = {128, 128, 128, 125},
    colorOn = {255, 255, 255, 255},
}
