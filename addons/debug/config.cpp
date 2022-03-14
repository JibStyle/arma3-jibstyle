class CfgPatches {
    class jib_hc {
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
        };
    };
};
