class CfgPatches {
    class jib_integration {
        name = "Jib Integration";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {
            "jib_earplugs",
            "jib_respawn",
            "jib_selectPlayer",
            "jib_transport",
        };
        units[] = {};
    };
};

class CfgFunctions {
    class jib_integration {
        class jib_integration {
            file = "x\jib\addons\integration";
            class postInit { recompile = 1; postInit = 1; };
        };
    };
};
