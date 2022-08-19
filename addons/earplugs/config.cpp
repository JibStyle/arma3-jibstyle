class CfgPatches {
    class jib_earplugs {
        name = "Jib Earplugs";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};
class CfgFunctions {
    class jib_earplugs {
        class jib_earplugs {
            file = "x\jib\addons\earplugs";
            class postInit { recompile = 1; postInit = 1; };
        };
    };
};
