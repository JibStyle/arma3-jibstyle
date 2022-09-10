class CfgPatches {
    class jib_support {
        name = "Jib Support";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_support_moduleCreate",
        };
    };
};
class CfgFunctions {
    class jib_support {
        class jib_support {
            file = "x\jib\addons\support";
            class support { recompile = 1; preInit = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_support: NO_CATEGORY { displayName = "Jib Support"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_support_module: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_support";
    };
    class jib_support_moduleCreate: jib_support_module {
        scopeCurator=2;
        displayName = "Create Support System";
        function = "jib_support_moduleCreate";
    };
};
