class CfgPatches {
    class jib_traffic {
        name = "JibStyle Traffic";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_traffic {
        class jib_traffic {
            file = "x\jib\addons\traffic";
            class traffic {recompile = 1; preInit = 1;};
        };
    };
};
