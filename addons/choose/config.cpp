class CfgPatches {
    class jib_choose {
        name = "JibStyle Choose";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class jib_choose {
        class jib_choose {
            file = "x\jib\addons\choose";
            class choose { preInit = 1; recompile = 1; };
        };
    };
};
