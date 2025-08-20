class CfgPatches {
    class jib_ao {
        name = "JibStyle AO";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_ao_module_building_add_nearest",
            "jib_ao_module_building_add_100",
            "jib_ao_module_building_add_500",
            "jib_ao_module_building_add_100000",
            "jib_ao_module_building_remove_nearest",
            "jib_ao_module_building_remove_100",
            "jib_ao_module_building_remove_500",
            "jib_ao_module_building_reset",
            "jib_ao_module_group_add",
            "jib_ao_module_group_reset",
            "jib_ao_module_population_add",
            "jib_ao_module_population_reset",
            "jib_ao_module_population_start",
            "jib_ao_module_population_stop",
            "jib_ao_module_draw_start",
            "jib_ao_module_draw_stop",
        };
        weapons[] = {};
    };
};

class CfgFunctions {
    class jib_ao {
        class jib_ao {
            file = "x\jib\addons\ao";
            class ao {recompile = 1; preInit = 1;};
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_ao: NO_CATEGORY {displayName = "Jib AO";};
};

class CfgVehicles
{
    class Module_F;
    class jib_ao_module: Module_F {
        isGlobal = 1;
        curatorCanAttach = 1;
        category = "jib_ao";
    };
    class jib_ao_module_building_add_nearest: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Add Nearest";
        function = "jib_ao_module_building_add_nearest";
    };
    class jib_ao_module_building_add_100: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Add 100 m";
        function = "jib_ao_module_building_add_100";
    };
    class jib_ao_module_building_add_500: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Add 500 m";
        function = "jib_ao_module_building_add_500";
    };
    class jib_ao_module_building_add_100000: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Add All";
        function = "jib_ao_module_building_add_100000";
    };
    class jib_ao_module_building_remove_nearest: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Remove Nearest";
        function = "jib_ao_module_building_remove_nearest";
    };
    class jib_ao_module_building_remove_100: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Remove 100 m";
        function = "jib_ao_module_building_remove_100";
    };
    class jib_ao_module_building_remove_500: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Remove 500 m";
        function = "jib_ao_module_building_remove_500";
    };
    class jib_ao_module_building_reset: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Remove All";
        function = "jib_ao_module_building_reset";
    };
    class jib_ao_module_group_add: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Group Add";
        function = "jib_ao_module_group_add";
    };
    class jib_ao_module_group_reset: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Group Reset";
        function = "jib_ao_module_group_reset";
    };
    class jib_ao_module_population_add: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Population Add";
        function = "jib_ao_module_population_add";
    };
    class jib_ao_module_population_reset: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Population Reset";
        function = "jib_ao_module_population_reset";
    };
    class jib_ao_module_population_start: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Population Start";
        function = "jib_ao_module_population_start";
    };
    class jib_ao_module_population_stop: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Population Stop";
        function = "jib_ao_module_population_stop";
    };
    class jib_ao_module_draw_start: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Draw Start";
        function = "jib_ao_module_draw_start";
    };
    class jib_ao_module_draw_stop: jib_ao_module {
        scopeCurator = 2;
        displayName = "AO Building Draw Stop";
        function = "jib_ao_module_draw_stop";
    };
};
