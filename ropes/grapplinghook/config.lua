grapplinghookConfig = {

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
    },
    grapplinghook = {
        model = "h4_prop_h4_rope_hook_01a",
        bonePos = "SKEL_R_Hand",
        entityOffset = vector3(0.0, 0.0, -0.5),
        noCollision = true,
        fromOffset = vector3(0.0, 0.0, -0.07),
        toOffset = vector3(0.0, 0.0, 0.1),
        useCoords = true,
    },
    righthand = {
        model = "prop_golf_ball",
        bone = "SKEL_R_Hand",
        offset = vector3(0.1, 0.01, 0.0),
        invisible = true,
    },
    lefthand = {
        model = "prop_golf_ball",
        bone = "SKEL_L_Hand",
        offset = vector3(0.1, -0.01, 0.0),
        invisible = true,
    },
    pelvis = {
        model = "prop_golf_ball",
        bone = "SKEL_Pelvis",
    },
}

grapplinghookConfig.ropes = {
    lefttorighthands = {
        fromBone = "SKEL_L_Hand",
        fromOffset = vector3(0.0, 0.0, -0.08),
        toBone = "SKEL_R_Hand",
        toOffset = vector3(0.0, 0.0, -0.07),
        maxLength = 1.5,
        ropeType = 4
    },
}

grapplinghookConfig.animations = {
    throw = {
        dict = "weapons@projectile@",
        name = "throw_m_fb_stand",
    },
    unthrow = {
        dict = "weapons@projectile@",
        name = "static_drop",
    },
}
