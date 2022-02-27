class CfgPatches {
    class jib_modules {
        name = "Jib Modules";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_modules_aiLasers",
            "jib_modules_devCopyPositionASL",
            "jib_modules_devCopyPositionATL",
            "jib_modules_devSelectEntity",
            "jib_modules_hcPromote",
            "jib_modules_hcDemote",
            "jib_modules_hcAdd",
            "jib_modules_hcRemove",
            "jib_modules_hcDebug",
            "jib_modules_selectPlayerFrom",
            "jib_modules_selectPlayerTo",
            "jib_modules_selectPlayerSelf",
            "jib_modules_token", // Doesn't work
        };
    };
};

class CfgFunctions {
    class jib_modules {
        class jib_modules {
            file = "x\jib\addons\modules";
            class aiLasers { recompile = 1; };
            class devCopyPositionASL { recompile = 1; };
            class devCopyPositionATL { recompile = 1; };
            class devSelectEntity { recompile = 1; };
            class hcPromote { recompile = 1; };
            class hcDemote { recompile = 1; };
            class hcAdd { recompile = 1; };
            class hcRemove { recompile = 1; };
            class hcDebug { recompile = 1; };
            class selectPlayerFrom { recompile = 1; };
            class selectPlayerTo { recompile = 1; };
            class selectPlayerSelf { recompile = 1; };
            class tokenInit { recompile = 1; preInit = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_ai: NO_CATEGORY { displayName = "Jib AI"; };
    class jib_dev: NO_CATEGORY { displayName = "Jib Dev"; };
    class jib_hc: NO_CATEGORY { displayName = "Jib HC"; };
    class jib_selectPlayer: NO_CATEGORY { displayName = "Jib Select Player"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_modules_aiLasers: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_ai";
        displayName = "Laser Control";
        function = "jib_modules_fnc_aiLasers";
    };
    class jib_modules_devCopyPositionASL: Module_F {
        isGlobal=1;
        scopeCurator=2;
        category = "jib_dev";
        displayName = "Copy Position ASL";
        function = "jib_dev_fnc_copyPositionASL";
    };
    class jib_modules_devCopyPositionATL: Module_F {
        isGlobal=1;
        scopeCurator=2;
        category = "jib_dev";
        displayName = "Copy Position ATL";
        function = "jib_dev_fnc_copyPositionATL";
    };
    class jib_modules_devSelectEntity: Module_F {
        isGlobal=1;
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_dev";
        displayName = "Select Entity";
        function = "jib_dev_fnc_selectEntity";
    };
    class jib_modules_hcPromote: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Promote";
        function = "jib_modules_fnc_hcPromote";
    };
    class jib_modules_hcDemote: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Demote";
        function = "jib_modules_fnc_hcDemote";
    };
    class jib_modules_hcAdd: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Add to Last";
        function = "jib_modules_fnc_hcAdd";
    };
    class jib_modules_hcRemove: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Remove";
        function = "jib_modules_fnc_hcRemove";
    };
    class jib_modules_hcDebug: Module_F {
        isGlobal=1;
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Print Debug Info";
        function = "jib_modules_fnc_hcDebug";
    };
    class jib_modules_selectPlayerSelf: Module_F {
        isGlobal=1;
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
        displayName = "Self";
        function = "jib_modules_fnc_selectPlayerSelf";
    };
    class jib_modules_selectPlayerFrom: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
        displayName = "From";
        function = "jib_modules_fnc_selectPlayerFrom";
    };
    class jib_modules_selectPlayerTo: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
        displayName = "To";
        function = "jib_modules_fnc_selectPlayerTo";
    };
    class jib_modules_token: Module_F {};
};
