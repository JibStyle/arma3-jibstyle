class CfgPatches {
    class jib_lambs {
        name = "JibStyle LAMBS";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_lambs {
        class jib_lambs {
            file = "x\jib\addons\lambs";
            class lambs { recompile = 1; preInit = 1; };
        };
    };
};
