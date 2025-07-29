class CfgPatches {
    class jib_ao {
        name = "JibStyle AO";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_ao {
        class jib_ao {
            file = "x\jib\addons\ao";
            class ao {recompile = 1; preInit = 1;};
        };
    };
};
