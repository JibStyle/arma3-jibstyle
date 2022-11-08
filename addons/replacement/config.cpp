class CfgPatches {
    class jib_replacement {
        name = "JibStyle Replacement";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_replacement_moduleRegister",
            "jib_replacement_moduleReplace",
        };
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_replacement {
        class jib_replacement {
            file = "x\jib\addons\replacement";
            class replacement { preInit = 1; recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_replacement: NO_CATEGORY { displayName = "Jib Replacement"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_replacement_module: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_replacement";
    };
    class jib_replacement_moduleRegister: jib_replacement_module {
        scopeCurator=2;
        displayName = "Replacement Register";
        function = "jib_replacement_moduleRegister";
    };
    class jib_replacement_moduleReplace: jib_replacement_module {
        scopeCurator=2;
        displayName = "Replacement Replace";
        function = "jib_replacement_moduleReplace";
    };
};
