class CfgPatches {
    class jib_debug {
        name = "Jib Debug";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_debug_moduleCopyPositionASL",
            "jib_debug_moduleCopyPositionATL",
            "jib_debug_moduleSelectEntity",
        };
    };
};

class CfgFunctions {
    class jib_debug {
        class jib_debug {
            file = "x\jib\addons\debug";
            class debug { recompile = 1; preInit = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_debug: NO_CATEGORY { displayName = "Jib Debug"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_debug_module: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_debug";
    };
    class jib_debug_moduleCopyPositionASL: jib_debug_module {
        scopeCurator=2;
        displayName = "Copy Position ASL";
        function = "jib_debug_moduleCopyPositionASL";
    };
    class jib_debug_moduleCopyPositionATL: jib_debug_module {
        scopeCurator=2;
        displayName = "Copy Position ATL";
        function = "jib_debug_moduleCopyPositionATL";
    };
    class jib_debug_moduleSelectEntity: jib_debug_module {
        scopeCurator=2;
        displayName = "Select Entity";
        function = "jib_debug_moduleSelectEntity";
    };
};
