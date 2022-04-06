class CfgPatches {
    class jib_debug {
        name = "Jib Debug";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};
class CfgFunctions {
    class jib_debug {
        class jib_debug {
            file = "x\jib\addons\debug";
            class log { recompile = 1;};
            class drawSetup { recompile = 1;};
            class drawTeardown { recompile = 1;};
            class drawAdd { recompile = 1;};
            class drawRemove { recompile = 1;};
            class preInit { recompile = 1; preInit = 1; };
        };
    };
};
