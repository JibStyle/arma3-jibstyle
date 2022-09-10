class CfgPatches {
    class jib_misc {
        name = "JibStyle Misc";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_misc_moduleReplaceFrom",
            "jib_misc_moduleReplaceTo",
            "jib_misc_moduleReplaceToUncrewed",
            "jib_misc_modulePushGroupIDs",
        };
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_misc {
        class jib_misc {
            file = "x\jib\addons\misc";
            class misc { recompile = 1; preInit = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_misc: NO_CATEGORY { displayName = "Jib Misc"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_misc_module: Module_F {
        isGlobal=1; // All machines (not JIP)
        curatorCanAttach=1;
        category = "jib_hc";
    };
    class jib_misc_moduleReplaceFrom: jib_misc_module {
        scopeCurator=2;
        displayName = "Misc Replace From";
        function = "jib_misc_moduleReplaceFrom";
    };
    class jib_misc_moduleReplaceTo: jib_misc_module {
        scopeCurator=2;
        displayName = "Misc Replace To";
        function = "jib_misc_moduleReplaceTo";
    };
    class jib_misc_moduleReplaceToUncrewed: jib_misc_module {
        scopeCurator=2;
        displayName = "Misc Replace To (Uncrewed)";
        function = "jib_misc_moduleReplaceToUncrewed";
    };
    class jib_misc_modulePushGroupIDs: jib_misc_module {
        scopeCurator=2;
        displayName = "Misc Push Group IDs";
        function = "jib_misc_modulePushGroupIDs";
    };
};
