class CfgPatches {
    class jib_modules {
        name = "Jib Modules";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_modules_aiLasers",
            "jib_modules_debug",
            "jib_modules_devCopyPositionASL",
            "jib_modules_devCopyPositionATL",
            "jib_modules_devSelectEntity",
            "jib_modules_hcPromote",
            "jib_modules_hcDemote",
            "jib_modules_hcAdd",
            "jib_modules_hcRemove",
            "jib_modules_hcDebug",
            "jib_modules_logistics_paradrop",
            "jib_modules_logistics_paradrop_halo",
            "jib_modules_logistics_rtb",
            "jib_modules_logistics_start",
            "jib_modules_logistics_wait",
            "jib_modules_misc_replaceFrom",
            "jib_modules_misc_replaceTo",
            "jib_modules_misc_replaceToUncrewed",
            "jib_modules_misc_syncGroupIDs",
            "jib_modules_objectives_hostage",
            "jib_modules_objectives_hostage_injured",
            "jib_modules_selectPlayerFrom",
            "jib_modules_selectPlayerTo",
            "jib_modules_selectPlayerSelf",
            "jib_modules_supportSystem",
            "jib_modules_synchronizationSyncFrom",
            "jib_modules_synchronizationSyncTo",
            "jib_modules_synchronizationUnsyncFrom",
            "jib_modules_synchronizationUnsyncTo",
            "jib_modules_teleport_all",
            "jib_modules_teleport_from",
            "jib_modules_teleport_self",
            "jib_modules_teleport_to",
            "jib_modules_token",
            "jib_modules_wp_guard",
        };
    };
};

class CfgFunctions {
    class jib_modules {
        class jib_modules {
            file = "x\jib\addons\modules";
            class aiLasers { recompile = 1; };
            class debug { recompile = 1; };
            class devCopyPositionASL { recompile = 1; };
            class devCopyPositionATL { recompile = 1; };
            class devSelectEntity { recompile = 1; };
            class hcPromote { recompile = 1; };
            class hcDemote { recompile = 1; };
            class hcAdd { recompile = 1; };
            class hcRemove { recompile = 1; };
            class hcDebug { recompile = 1; };
            class objectives_hostage { recompile = 1; };
            class objectives_hostage_injured { recompile = 1; };
            class logistics_paradrop { recompile = 1; };
            class logistics_paradrop_halo { recompile = 1; };
            class logistics_rtb { recompile = 1; };
            class logistics_start { recompile = 1; };
            class logistics_wait { recompile = 1; };
            class misc_replaceFrom { recompile = 1; };
            class misc_replaceTo { recompile = 1; };
            class misc_replaceToUncrewed { recompile = 1; };
            class misc_syncGroupIDs { recompile = 1; };
            class selectPlayerFrom { recompile = 1; };
            class selectPlayerTo { recompile = 1; };
            class selectPlayerSelf { recompile = 1; };
            class supportSystem { recompile = 1; };
            class synchronizationSyncFrom { recompile = 1; };
            class synchronizationSyncTo { recompile = 1; };
            class synchronizationUnsyncFrom { recompile = 1; };
            class synchronizationUnsyncTo { recompile = 1; };
            class teleportAll { recompile = 1; };
            class teleportFrom { recompile = 1; };
            class teleportSelf { recompile = 1; };
            class teleportTo { recompile = 1; };
            class tokenInit { recompile = 1; preInit = 1; };
            class wp_guard { recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_ai: NO_CATEGORY { displayName = "Jib AI"; };
    class jib_debug: NO_CATEGORY { displayName = "Jib Debug"; };
    class jib_dev: NO_CATEGORY { displayName = "Jib Dev"; };
    class jib_hc: NO_CATEGORY { displayName = "Jib HC"; };
    class jib_misc: NO_CATEGORY { displayName = "Jib Misc"; };
    class jib_objectives: NO_CATEGORY { displayName = "Jib Objectives"; };
    class jib_logistics: NO_CATEGORY { displayName = "Jib Logistics"; };
    class jib_selectPlayer: NO_CATEGORY { displayName = "Jib Select Player"; };
    class jib_support: NO_CATEGORY { displayName = "Jib Support"; };
    class jib_synchronization: NO_CATEGORY { displayName = "Jib Sync"; };
    class jib_teleport: NO_CATEGORY { displayName = "Jib Teleport"; };
    class jib_token: NO_CATEGORY { displayName = "Jib Token"; };
    class jib_wp: NO_CATEGORY { displayName = "Jib Waypoints"; };
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
    class jib_modules_debug: Module_F {
        scope = 2; // 2: Eden, 1: Hidden (default)
        scopeCurator = 2;
        isGlobal = 1; // 0: Server (default), 1: All, 2: All + JIP
        category = "jib_debug";
        displayName = "Debug";
        function = "jib_modules_fnc_debug";
        class Arguments {
            class jib_modules_debugFoo {
                displayName = "Foo";
                description = "For debugging.";
                defaultValue = "jib default";
                type="ArgTypeTEXT";
            };
        };
    };
    class jib_modules_devCopyPositionASL: Module_F {
        isGlobal=1;
        scopeCurator=2;
        category = "jib_dev";
        displayName = "Copy Position ASL";
        function = "jib_modules_fnc_devCopyPositionASL";
    };
    class jib_modules_devCopyPositionATL: Module_F {
        isGlobal=1;
        scopeCurator=2;
        category = "jib_dev";
        displayName = "Copy Position ATL";
        function = "jib_modules_fnc_devCopyPositionATL";
    };
    class jib_modules_devSelectEntity: Module_F {
        isGlobal=1;
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_dev";
        displayName = "Select Entity";
        function = "jib_modules_fnc_devSelectEntity";
    };
    class jib_modules_hcPromote: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "HC Promote";
        function = "jib_modules_fnc_hcPromote";
    };
    class jib_modules_hcDemote: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "HC Demote";
        function = "jib_modules_fnc_hcDemote";
    };
    class jib_modules_hcAdd: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "HC Add to Last";
        function = "jib_modules_fnc_hcAdd";
    };
    class jib_modules_hcRemove: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "HC Remove";
        function = "jib_modules_fnc_hcRemove";
    };
    class jib_modules_hcDebug: Module_F {
        isGlobal=1;
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "HC Print Debug Info";
        function = "jib_modules_fnc_hcDebug";
    };
    class jib_modules_logistics_paradrop: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_logistics";
        displayName = "Logistics Paradrop";
        function = "jib_modules_fnc_logistics_paradrop";
    };
    class jib_modules_logistics_paradrop_halo: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_logistics";
        displayName = "Logistics Paradrop (HALO)";
        function = "jib_modules_fnc_logistics_paradrop_halo";
    };
    class jib_modules_logistics_rtb: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_logistics";
        displayName = "Logistics RTB";
        function = "jib_modules_fnc_logistics_rtb";
    };
    class jib_modules_logistics_start: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_logistics";
        displayName = "Logistics Start";
        function = "jib_modules_fnc_logistics_start";
    };
    class jib_modules_logistics_wait: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_logistics";
        displayName = "Logistics Wait for Start";
        function = "jib_modules_fnc_logistics_wait";
    };
    class jib_modules_misc_replaceFrom: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_misc";
        displayName = "Misc Replace From";
        function = "jib_modules_fnc_misc_replaceFrom";
    };
    class jib_modules_misc_replaceTo: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_misc";
        displayName = "Misc Replace To";
        function = "jib_modules_fnc_misc_replaceTo";
    };
    class jib_modules_misc_replaceToUncrewed: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_misc";
        displayName = "Misc Replace To (Uncrewed)";
        function = "jib_modules_fnc_misc_replaceToUncrewed";
    };
    class jib_modules_misc_syncGroupIDs: Module_F {
        isGlobal = 1;
        scopeCurator=2;
        curatorCanAttach=0;
        category = "jib_misc";
        displayName = "Misc Sync Group IDs";
        function = "jib_modules_fnc_misc_syncGroupIDs";
    };
    class jib_modules_objectives_hostage: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_objectives";
        displayName = "Objective Hostage";
        function = "jib_modules_fnc_objectives_hostage";
    };
    class jib_modules_objectives_hostage_injured: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_objectives";
        displayName = "Objective Hostage (Injured)";
        function = "jib_modules_fnc_objectives_hostage_injured";
    };
    class jib_modules_selectPlayerSelf: Module_F {
        isGlobal=1;
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
        displayName = "Select Player Self";
        function = "jib_modules_fnc_selectPlayerSelf";
    };
    class jib_modules_selectPlayerFrom: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
        displayName = "Select Player From";
        function = "jib_modules_fnc_selectPlayerFrom";
    };
    class jib_modules_selectPlayerTo: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_selectPlayer";
        displayName = "Select Player To";
        function = "jib_modules_fnc_selectPlayerTo";
    };
    class jib_modules_supportSystem: Module_F {
        isGlobal=1;
        scopeCurator = 2;
        category = "jib_support";
        displayName = "Support Create System";
        function = "jib_modules_fnc_supportSystem";
    };
    class jib_modules_synchronizationSyncFrom: Module_F {
        scopeCurator = 2;
        category = "jib_synchronization";
        curatorCanAttach=1;
        displayName = "Sync From";
        function = "jib_modules_fnc_synchronizationSyncFrom";
    };
    class jib_modules_synchronizationSyncTo: Module_F {
        scopeCurator = 2;
        category = "jib_synchronization";
        curatorCanAttach=1;
        displayName = "Sync To";
        function = "jib_modules_fnc_synchronizationSyncTo";
    };
    class jib_modules_synchronizationUnsyncFrom: Module_F {
        scopeCurator = 2;
        category = "jib_synchronization";
        curatorCanAttach=1;
        displayName = "Unsync From";
        function = "jib_modules_fnc_synchronizationUnsyncFrom";
    };
    class jib_modules_synchronizationUnsyncTo: Module_F {
        scopeCurator = 2;
        category = "jib_synchronization";
        curatorCanAttach=1;
        displayName = "Unsync To";
        function = "jib_modules_fnc_synchronizationUnsyncTo";
    };
    class jib_modules_teleportAll: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_teleport";
        displayName = "Teleport All Players";
        function = "jib_modules_fnc_teleportAll";
    };
    class jib_modules_teleportFrom: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_teleport";
        displayName = "Teleport From";
        function = "jib_modules_fnc_teleportFrom";
    };
    class jib_modules_teleportSelf: Module_F {
        isGlobal=1;
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_teleport";
        displayName = "Teleport Self";
        function = "jib_modules_fnc_teleportSelf";
    };
    class jib_modules_teleportTo: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_teleport";
        displayName = "Teleport To";
        function = "jib_modules_fnc_teleportTo";
    };
    class jib_modules_token: Module_F {
        scope=2;
        displayName = "Token";
        category = "jib_token";
    };
    class jib_modules_wp_guard: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_wp";
        displayName = "Waypoint Guard";
        function = "jib_modules_fnc_wp_guard";
    };
};
