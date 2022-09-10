class CfgPatches {
    class jib_sync {
        name = "Jib Sync";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_sync_syncFrom",
            "jib_sync_syncTo",
            "jib_sync_unsyncFrom",
            "jib_sync_unsyncTo",
        };
    };
};

class CfgFunctions {
    class jib_sync {
        class jib_sync {
            file = "x\jib\addons\sync";
            class sync { preInit = 1; recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_sync: NO_CATEGORY { displayName = "Jib Sync"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_sync_module: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_sync";
    };
    class jib_sync_moduleSyncFrom: jib_sync_module {
        scopeCurator=2;
        displayName = "Sync From";
        function = "jib_sync_moduleSyncFrom";
    };
    class jib_sync_moduleSyncTo: jib_sync_module {
        scopeCurator=2;
        displayName = "Sync To";
        function = "jib_sync_moduleSyncTo";
    };
    class jib_sync_moduleUnsyncFrom: jib_sync_module {
        scopeCurator=2;
        displayName = "Unsync From";
        function = "jib_sync_moduleUnsyncFrom";
    };
    class jib_sync_moduleUnsyncTo: jib_sync_module {
        scopeCurator=2;
        displayName = "Unsync To";
        function = "jib_sync_moduleUnsyncTo";
    };
};
