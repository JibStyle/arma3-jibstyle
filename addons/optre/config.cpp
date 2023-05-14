class CfgPatches {
    class jib_optre {
        name = "JibStyle OPTRE";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_optre {
        class jib_optre {
            file = "x\jib\addons\optre";
            class optre { recompile = 1; preInit = 1; };
        };
    };
};
