class CfgPatches {
    class jib_modules {
        name = "Jib Modules";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
        };
    };
};

class CfgFunctions {
    class jib_modules {
        class jib_modules {
            file = "x\jib\addons\modules";
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_modules: NO_CATEGORY {
        displayName = "Jib Modules";
    };
};

class CfgVehicles
{
    class Module_F;
};
