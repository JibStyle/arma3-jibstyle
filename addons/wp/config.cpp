class CfgPatches {
    class jib_wp {
        name = "Jib Waypoint";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_wp_moduleGuard",
            "jib_wp_moduleWait",
            "jib_wp_moduleStart",
            "jib_wp_moduleParadrop",
            "jib_wp_moduleParadropHALO",
            "jib_wp_moduleRTB",
        };
    };
};

class CfgFunctions {
    class jib_wp {
        class jib_wp {
            file = "x\jib\addons\wp";
            class wp { preInit = 1; recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_wp: NO_CATEGORY { displayName = "Jib Waypoint"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_wp_module: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_wp";
    };
    class jib_wp_moduleGuard: jib_wp_module {
        scopeCurator=2;
        displayName = "Waypoint GUARD";
        function = "jib_wp_moduleGuard";
    };
    class jib_wp_moduleWait: jib_wp_module {
        scopeCurator=2;
        displayName = "Waypoint Wait";
        function = "jib_wp_moduleWait";
    };
    class jib_wp_moduleStart: jib_wp_module {
        scopeCurator=2;
        displayName = "Waypoint Start";
        function = "jib_wp_moduleStart";
    };
    class jib_wp_moduleParadrop: jib_wp_module {
        scopeCurator=2;
        displayName = "Waypoint Paradrop";
        function = "jib_wp_moduleParadrop";
    };
    class jib_wp_moduleParadropHALO: jib_wp_module {
        scopeCurator=2;
        displayName = "Waypoint Paradrop HALO";
        function = "jib_wp_moduleParadropHALO";
    };
    class jib_wp_moduleRTB: jib_wp_module {
        scopeCurator=2;
        displayName = "Waypoint RTB";
        function = "jib_wp_moduleRTB";
    };
};
