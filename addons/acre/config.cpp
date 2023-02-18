class CfgPatches {
    class jib_acre {
        name = "Jib ACRE";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {
        };
    };
};

class CfgFunctions {
    class jib_acre {
        class jib_acre {
            file = "x\jib\addons\acre";
            class acre { preInit = 1; recompile = 1; };
        };
    };
};
