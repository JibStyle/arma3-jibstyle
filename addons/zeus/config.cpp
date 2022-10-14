class CfgPatches {
    class jib_zeus {
        name = "Jib Zeus";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_zeus_moduleAddAllPlayers",
            "jib_zeus_moduleRemoveAllPlayers",
            "jib_zeus_moduleAddAllUnits",
            "jib_zeus_moduleRemoveAllUnits",
            "jib_zeus_moduleAddAllDead",
            "jib_zeus_moduleRemoveAllDead",
            "jib_zeus_moduleAddAllLogic",
            "jib_zeus_moduleRemoveAllLogic",
            "jib_zeus_moduleAddAllWest",
            "jib_zeus_moduleRemoveAllWest",
            "jib_zeus_moduleAddAllEast",
            "jib_zeus_moduleRemoveAllEast",
            "jib_zeus_moduleAddAllIndependent",
            "jib_zeus_moduleRemoveAllIndependent",
            "jib_zeus_moduleAddAllCivilian",
            "jib_zeus_moduleRemoveAllCivilian",
        };
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_zeus {
        class jib_zeus {
            file = "x\jib\addons\zeus";
            class zeus {recompile = 1; preInit = 1;};
            class activateAddons {recompile = 1; preInit = 1;};
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_zeus: NO_CATEGORY { displayName = "Jib Zeus"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_zeus_module: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_zeus";
    };
    class jib_zeus_moduleAddAllPlayers: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Add All Players";
        function = "jib_zeus_moduleAddAllPlayers";
    };
    class jib_zeus_moduleRemoveAllPlayers: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Remove All Players";
        function = "jib_zeus_moduleRemoveAllPlayers";
    };
    class jib_zeus_moduleAddAllUnits: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Add All Units";
        function = "jib_zeus_moduleAddAllUnits";
    };
    class jib_zeus_moduleRemoveAllUnits: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Remove All Units";
        function = "jib_zeus_moduleRemoveAllUnits";
    };
    class jib_zeus_moduleAddAllDead: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Add All Dead";
        function = "jib_zeus_moduleAddAllDead";
    };
    class jib_zeus_moduleRemoveAllDead: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Remove All Dead";
        function = "jib_zeus_moduleRemoveAllDead";
    };
    class jib_zeus_moduleAddAllLogic: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Add All Logic";
        function = "jib_zeus_moduleAddAllLogic";
    };
    class jib_zeus_moduleRemoveAllLogic: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Remove All Logic";
        function = "jib_zeus_moduleRemoveAllLogic";
    };
    class jib_zeus_moduleAddAllWest: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Add All West";
        function = "jib_zeus_moduleAddAllWest";
    };
    class jib_zeus_moduleRemoveAllWest: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Remove All West";
        function = "jib_zeus_moduleRemoveAllWest";
    };
    class jib_zeus_moduleAddAllEast: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Add All East";
        function = "jib_zeus_moduleAddAllEast";
    };
    class jib_zeus_moduleRemoveAllEast: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Remove All East";
        function = "jib_zeus_moduleRemoveAllEast";
    };
    class jib_zeus_moduleAddAllIndependent: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Add All Independent";
        function = "jib_zeus_moduleAddAllIndependent";
    };
    class jib_zeus_moduleRemoveAllIndependent: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Remove All Independent";
        function = "jib_zeus_moduleRemoveAllIndependent";
    };
    class jib_zeus_moduleAddAllCivilian: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Add All Civilian";
        function = "jib_zeus_moduleAddAllCivilian";
    };
    class jib_zeus_moduleRemoveAllCivilian: jib_zeus_module {
        scopeCurator=2;
        displayName = "Zeus Remove All Civilian";
        function = "jib_zeus_moduleRemoveAllCivilian";
    };
};
