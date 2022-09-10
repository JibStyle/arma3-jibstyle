class CfgPatches {
    class jib_objective {
        name = "Jib Objective";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_objective_moduleHostage",
            "jib_objective_moduleHostageInjured",
        };
    };
};

class CfgFunctions {
    class jib_objective {
        class jib_objective {
            file = "x\jib\addons\objective";
            class objective { preInit = 1; recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_objective: NO_CATEGORY { displayName = "Jib Objective"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_objective_module: Module_F {
        isGlobal=1; // All machines (not JIP)
        curatorCanAttach=1;
        category = "jib_objective";
    };
    class jib_objective_moduleHostage: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Hostage";
        function = "jib_objective_moduleHostage";
    };
    class jib_objective_moduleHostageInjured: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Hostage (Injured)";
        function = "jib_objective_moduleHostageInjured";
    };
};
