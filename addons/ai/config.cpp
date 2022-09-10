class CfgPatches {
    class jib_ai {
        name = "JibStyle AI";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_ai_moduleLaserControlEnable",
            "jib_ai_moduleLaserControlDisable",
        };
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_ai {
        class jib_ai {
            file = "x\jib\addons\ai";
            class ai { preInit = 1; recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_ai: NO_CATEGORY { displayName = "Jib AI"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_ai_module: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_ai";
    };
    class jib_ai_moduleLaserControlEnable: jib_ai_module {
        scopeCurator=2;
        displayName = "Laser Control Enable";
        function = "jib_ai_moduleLaserControlEnable";
    };
    class jib_ai_moduleLaserControlDisable: jib_ai_module {
        scopeCurator=2;
        displayName = "Laser Control Disable";
        function = "jib_ai_moduleLaserControlDisable";
    };
};
