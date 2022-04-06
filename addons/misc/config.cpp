class CfgPatches {
    class jib_misc {
        name = "JibStyle Misc";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_misc {
        class jib_misc {
            file = "x\jib\addons\misc";
            class postInit { recompile = 1; postInit = 1; };
        };
    };
};
