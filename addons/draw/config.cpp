class CfgPatches {
    class jib_draw {
        name = "Jib Draw";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_draw_moduleSetupLocal",
            "jib_draw_moduleTeardownLocal",
            "jib_draw_moduleSetupGlobal",
            "jib_draw_moduleTeardownGlobal",
        };
    };
};

class CfgFunctions {
    class jib_draw {
        class jib_draw {
            file = "x\jib\addons\draw";
            class draw { recompile = 1; preInit = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_draw: NO_CATEGORY { displayName = "Jib Draw"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_draw_module: Module_F {
        isGlobal=1; // All machines (not JIP)
        curatorCanAttach=1;
        category = "jib_draw";
    };
    class jib_draw_moduleSetupLocal: jib_draw_module {
        scopeCurator=2;
        displayName = "Draw Setup Local";
        function = "jib_draw_moduleSetupLocal";
    };
    class jib_draw_moduleTeardownLocal: jib_draw_module {
        scopeCurator=2;
        displayName = "Draw Teardown Local";
        function = "jib_draw_moduleTeardownLocal";
    };
    class jib_draw_moduleSetupGlobal: jib_draw_module {
        scopeCurator=2;
        displayName = "Draw Setup Global";
        function = "jib_draw_moduleSetupGlobal";
    };
    class jib_draw_moduleTeardownGlobal: jib_draw_module {
        scopeCurator=2;
        displayName = "Draw Teardown Global";
        function = "jib_draw_moduleTeardownGlobal";
    };
};
