Config = {
    DefaultLang = "en",
    PrefixMsg = "[ROPEHANDLER]",
    ColorsMsg = {
        debug = "^8", -- Gray
        success = "^2", -- Green
        info = "^4", -- Blue
        warning = "^3", -- Yellow
        error = "^1", -- Red
        default = "^7" -- White (default)
    }
    Debug = true,
    ShowLine = true,
    ColorLine = { 255, 0, 0, 255 },
    CrosshairDict = "helicopterhud",
    CrosshaireName = "hud_dest",
    CrosshairColorOff = {128, 128, 128, 125},
    CrosshairColorOn = {255, 255, 255, 255},
    Colors = {
        debug = { 0, 255, 0 },
        info = { 0, 125, 255 },
        warning = { 255, 255, 0 },
        error = { 255, 0, 0 },
    },
    RopeTypes = {
        "grapplinghook",
        "lasso",
    },
}

Config.GrapplingHook = {
    distance = 50.0,
    items = {
        lefthand = {
            model = "prop_golf_ball",
            bone = 18905,
            offset = vector3(0.1, -0.01, 0.0),
        },
        righthand = {
            model = "prop_golf_ball",
            bone = 57005,
            offset = vector3(0.1, 0.01, 0.0),
        },
        pelvis = {
            model = "prop_golf_ball",
            bone = 11816,
        },
        rope = {
            model = "prop_stag_do_rope",
            prop = "lefthand",
            offset = vector3(0.2, 0.01, 0.0),
            visible = true,
            collision = false,
        },
        grappling = {
            model = "h4_prop_h4_rope_hook_01a",
            from = "righthand",
            offset = vector3(0.0, 0.1, -0.4),
            visible = true,
            collision = false,
        },

    },
    ropes = {
        ropel2r = {
            from = "lefthand",
            to = "righthand",
            type = 4,
        },
        roper2g = {
            from = "righthand",
            to = "grappling",
            maxRopeLength = true,
            type = 4,
            toOffset = vector3(0.0, 0.0, 0.1),
        },
    },
    animations = {
        throw = {
            dict = "weapons@projectile@",
            name = "throw_m_fb_stand",
        },
        unthrow = {
            dict = "weapons@projectile@",
            name = "static_drop",
        },
    },
    orders = {
        "lefthand",
        "righthand",
        "pelvis",
        "rope",
        "grappling",
    }
}

Config.Lasso = {
    distance = 50.0,
    items = {
        lefthand = {
            model = "prop_golf_ball",
            bone = 18905,
            offset = vector3(0.1, -0.01, 0.0),
        },
        righthand = {
            model = "prop_golf_ball",
            bone = 57005,
            offset = vector3(0.1, 0.01, 0.0),
        },
        lasso = {
            model = "prop_stag_do_rope",
            from = "righthand",
            offset = vector3(0.0, 0.1, -0.4),
            visible = true,
            collision = false,
        },
    },
    ropes = {
        ropel2r = {
            from = "lefthand",
            to = "righthand",
            type = 4,
        },
        roper2g = {
            from = "righthand",
            to = "lasso",
            maxRopeLength = true,
            type = 4,
            toOffset = vector3(0.0, 0.0, 0.1),
        },
    },
    animations = {
        throw = {
            dict = "weapons@projectile@",
            name = "throw_m_fb_stand",
            wait = 500,
        },
        unthrow = {
            dict = "weapons@projectile@",
            name = "static_drop",
        },
    },
    orders = {
        "lefthand",
        "righthand",
        "lasso",
    }
}
