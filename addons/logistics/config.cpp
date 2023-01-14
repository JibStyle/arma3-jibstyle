class CfgPatches {
    class jib_logistics {
        name = "Jib Logistics";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_logistics {
        class jib_logistics {
            file = "x\jib\addons\logistics";
            class logistics { recompile = 1; preInit = 1; };
        };
    };
};
