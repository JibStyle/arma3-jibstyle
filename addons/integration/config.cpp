class CfgPatches {
    class jib_integration {
        name = "Jib Integration";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {
            "jib_ai",
            "jib_cereal",
            "jib_debug",
            "jib_draw",
            "jib_emitter",
            "jib_earplugs",
            "jib_group",
            "jib_handler",
            "jib_hc",
            "jib_log",
            "jib_logistics",
            "jib_menu",
            "jib_misc",
            "jib_module",
            "jib_para",
            "jib_objective",
            "jib_random",
            "jib_selectPlayer",
            "jib_service",
            "jib_spawn",
            "jib_sync",
            "jib_teleport",
            "jib_transport",
            "jib_wp",
        };
        units[] = {};
    };
};

class CfgFunctions {
    class jib_integration {
        class jib_integration {
            file = "x\jib\addons\integration";
            class integration { recompile = 1; preInit = 1; };
        };
    };
};
