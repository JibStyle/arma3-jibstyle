class CfgPatches {
    class jib_modules {
        name = "Jib Modules";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_modules_aiLasers",
            "jib_modules_hcPromote",
            "jib_modules_hcDemote",
            "jib_modules_hcAdd",
            "jib_modules_hcRemove",
            "jib_modules_hcDebug",
            "jib_modules_selectPlayerFrom",
            "jib_modules_selectPlayerTo",
            "jib_modules_selectPlayerSelf",
        };
    };
};

class CfgFunctions {
    class jib_modules {
        class jib_modules {
            file = "x\jib\addons\modules";
            class aiLasers { recompile = 1; };
            class hcPromote { recompile = 1; };
            class hcDemote { recompile = 1; };
            class hcAdd { recompile = 1; };
            class hcRemove { recompile = 1; };
            class hcDebug { recompile = 1; };
            class selectPlayerFrom { recompile = 1; };
            class selectPlayerTo { recompile = 1; };
            class selectPlayerSelf { recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_ai: NO_CATEGORY { displayName = "Jib AI"; };
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
};
