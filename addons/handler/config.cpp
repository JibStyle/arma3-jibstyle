class CfgPatches {
    class jib_handler {
        name = "Jib Handler";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_handler {
        class jib_handler {
            file = "x\jib\addons\handler";
            class handler { recompile = 1; preInit = 1; };
        };
    };
};
