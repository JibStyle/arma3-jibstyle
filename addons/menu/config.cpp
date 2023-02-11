class CfgPatches {
    class jib_menu {
        name = "Jib Menu";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_menu {
        class jib_menu {
            file = "x\jib\addons\menu";
            class menu { recompile = 1; preInit = 1; };
        };
    };
};
