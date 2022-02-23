class CfgPatches {
    class jib_selectPlayer {
        name = "Jib Select Player";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_selectPlayer_self",
            "jib_selectPlayer_from",
            "jib_selectPlayer_to",
        };
    };
};

class CfgFunctions {
    class jib_selectPlayer {
        class jib_selectPlayer {
            file = "x\jib\addons\selectPlayer";
            class self { recompile = 1; };
            class from { recompile = 1; };
            class to { recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_selectPlayer: NO_CATEGORY {
        displayName = "Jib Select Player";
    };
};

class CfgVehicles
{
    class Module_F;
    class jib_selectPlayer_self: Module_F {
        isGlobal=1;
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
        displayName = "Self";
        function = "jib_selectPlayer_fnc_self";
    };
    class jib_selectPlayer_from: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
        displayName = "From";
        function = "jib_selectPlayer_fnc_from";
    };
    class jib_selectPlayer_to: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
        displayName = "To";
        function = "jib_selectPlayer_fnc_to";
    };
};
