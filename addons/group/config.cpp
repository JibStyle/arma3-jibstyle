class CfgPatches {
    class jib_group {
        name = "JibStyle Group";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_group {
        class jib_group {
            file = "x\jib\addons\group";
            class group { recompile = 1; preInit = 1; };
        };
    };
};
