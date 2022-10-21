class CfgPatches {
    class jib_log {
        name = "Jib Log";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_log {
        class jib_log {
            file = "x\jib\addons\log";
            class log { recompile = 1; preInit = 1; };
        };
    };
};
