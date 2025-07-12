class CfgPatches {
    class jib_patrol {
        name = "JibStyle Patrol";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_patrol {
        class jib_patrol {
            file = "x\jib\addons\patrol";
            class patrol {recompile = 1; preInit = 1;};
        };
    };
};
