class CfgPatches {
    class jib_selectPlayer {
        name = "Jib Select Player";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_selectPlayer_moduleFrom",
            "jib_selectPlayer_moduleTo",
            "jib_selectPlayer_moduleSelf",
        };
    };
};

class CfgFunctions {
    class jib_selectPlayer {
        class jib_selectPlayer {
            file = "x\jib\addons\selectPlayer";
            class selectPlayer { recompile = 1; preInit = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_selectPlayer: NO_CATEGORY { displayName = "Jib Select Player"; };
};

class CfgVehicles {
    class Module_F;
    class jib_modules_selectPlayer: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
    };
    class jib_modules_selectPlayerFrom: jib_modules_selectPlayer {
        scopeCurator=2;
        displayName = "Select Player From";
        function = "jib_selectPlayer_moduleFrom";
    };
    class jib_modules_selectPlayerTo: jib_modules_selectPlayer {
        scopeCurator=2;
        displayName = "Select Player To";
        function = "jib_selectPlayer_moduleTo";
    };
    class jib_modules_selectPlayerSelf: jib_modules_selectPlayer {
        scopeCurator=2;
        displayName = "Select Player Self";
        function = "jib_selectPlayer_moduleSelf";
    };
};
