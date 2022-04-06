class CfgPatches {
    class jib_random {
        name = "JibStyle Random";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_random {
        class jib_random {
            file = "x\jib\addons\random";
            class preInit { recompile = 1; preInit = 1; };
            class classify { recompile = 1; };
            class random { recompile = 1; };
        };
    };
};
