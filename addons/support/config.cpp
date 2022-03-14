class CfgPatches {
    class jib_support {
        name = "Jib Support";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};
class CfgFunctions {
    class jib_support {
        class jib_support {
            file = "x\jib\addons\support";
            class createSystem { recompile = 1; };
            class preInit { recompile = 1; preInit = 1; };
        };
    };
};
