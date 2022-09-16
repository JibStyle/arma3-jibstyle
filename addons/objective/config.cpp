class CfgPatches {
    class jib_objective {
        name = "Jib Objective";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_objective_moduleDataTerminalNone",
            "jib_objective_moduleDataTerminalAll",
            "jib_objective_moduleDataTerminalWest",
            "jib_objective_moduleDataTerminalEast",
            "jib_objective_moduleDataTerminalIndependent",
            "jib_objective_moduleDataTerminalCivilian",
            "jib_objective_moduleHostageNone",
            "jib_objective_moduleHostageAll",
            "jib_objective_moduleHostageWest",
            "jib_objective_moduleHostageEast",
            "jib_objective_moduleHostageIndependent",
            "jib_objective_moduleHostageCivilian",
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
    class jib_objective_moduleDataTerminalNone: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Data Terminal None";
        function = "jib_objective_moduleDataTerminalNone";
    };
    class jib_objective_moduleDataTerminalAll: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Data Terminal All";
        function = "jib_objective_moduleDataTerminalAll";
    };
    class jib_objective_moduleDataTerminalWest: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Data Terminal West";
        function = "jib_objective_moduleDataTerminalWest";
    };
    class jib_objective_moduleDataTerminalEast: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Data Terminal East";
        function = "jib_objective_moduleDataTerminalEast";
    };
    class jib_objective_moduleDataTerminalIndependent: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Data Terminal Independent";
        function = "jib_objective_moduleDataTerminalIndependent";
    };
    class jib_objective_moduleDataTerminalCivilian: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Data Terminal Civilian";
        function = "jib_objective_moduleDataTerminalCivilian";
    };
    class jib_objective_moduleHostageNone: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Hostage None";
        function = "jib_objective_moduleHostageNone";
    };
    class jib_objective_moduleHostageAll: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Hostage All";
        function = "jib_objective_moduleHostageAll";
    };
    class jib_objective_moduleHostageWest: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Hostage West";
        function = "jib_objective_moduleHostageWest";
    };
    class jib_objective_moduleHostageEast: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Hostage East";
        function = "jib_objective_moduleHostageEast";
    };
    class jib_objective_moduleHostageIndependent: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Hostage Independent";
        function = "jib_objective_moduleHostageIndependent";
    };
    class jib_objective_moduleHostageCivilian: jib_objective_module {
        scopeCurator=2;
        displayName = "Objective Hostage Civilian";
        function = "jib_objective_moduleHostageCivilian";
    };
};
