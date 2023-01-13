class CfgPatches {
    class jib_spawn {
        name = "Jib Spawn";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {
        };
    };
};

class CfgFunctions {
    class jib_spawn {
        class jib_spawn {
            file = "x\jib\addons\spawn";
            class spawn { preInit = 1; recompile = 1; };
        };
    };
};
