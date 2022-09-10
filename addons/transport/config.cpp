class CfgPatches {
    class jib_transport {
        name = "Jib Transport";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};
class CfgFunctions {
    class jib_transport {
        class jib_transport {
            file = "x\jib\addons\transport";
            class transport { recompile = 1; preInit = 1; };
        };
    };
};
