class CfgPatches {
    class jib_ai {
        name = "JibStyle AI";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_ai_enableLaserControl",
        };
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_ai {
        class jib_ai {
            file = "x\jib\addons\ai";
            class enableLaserControl { recompile = 1; };
        };
    };
};
class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_ai: NO_CATEGORY {
        displayName = "Jib AI";
    };
};
class CfgVehicles {
    class Module_F;
    class jib_ai_enableLaserControl: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_ai";
        displayName = "Laser Control";
        function = "jib_ai_fnc_enableLaserControl";
    };
};
