grapplinghookConfig = {
    distance = 50.0,
    controls = {
        37, -- tab
        24, -- leftClick
        257, -- leftClick
        25, -- rightClick
        96, -- scrollUp
        97, -- scrollDown
    }
}

grapplinghookConfig.items = {
    rope = {
        model = "prop_stag_do_rope",
        bone = "SKEL_L_Hand",
        offset = vector3(0.3, 0.0, 0.02),
        rotation = vector3(-40.0, 0.0, 0.0),
        maxLength = 1.5,
        noCollision = true,
        useCoords = true,
        itemname = "item_rope",
        ropename = "rope_rope",
    },
    grapplinghook = {
        model = "h4_prop_h4_rope_hook_01a",
        bonePos = "SKEL_R_Hand",
        entityOffset = vector3(0.0, 0.0, -0.5),
        noCollision = true,
        fromOffset = vector3(0.0, 0.0, -0.07),
        toOffset = vector3(0.0, 0.0, 0.1),
        useCoords = true,
        itemname = "item_grapplinghook",
        ropename = "rope_grapplinghook",
    },
    righthand = {
        model = "prop_golf_ball",
        bone = "SKEL_R_Hand",
        offset = vector3(0.1, 0.01, 0.0),
        invisible = true,
        itemname = "ghrighthand",
    },
    lefthand = {
        model = "prop_golf_ball",
        bone = "SKEL_L_Hand",
        offset = vector3(0.1, -0.01, 0.0),
        invisible = true,
        itemname = "ghlefthand",
    },
    pelvis = {
        model = "prop_golf_ball",
        bone = "SKEL_Pelvis",
        itemname = "ghpelvis",
    },
}

grapplinghookConfig.crosshair = {
    showLine = true,
    colorLine = { 255, 0, 0, 255 },
    crosshairDict = "helicopterhud",
    crosshaireName = "hud_dest",
    colorOff = {128, 128, 128, 125},
    colorOn = {255, 255, 255, 255},
}

grapplinghookConfig.animations = {
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
