class CfgPatches {
    class jib_teleport {
        name = "Jib Teleport";
        author = "JibStyle";
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_teleport_moduleAll",
            "jib_teleport_moduleFrom",
            "jib_teleport_moduleSelf",
            "jib_teleport_moduleTo",
        };
    };
};

class CfgFunctions {
    class jib_teleport {
        class jib_teleport {
            file = "x\jib\addons\teleport";
            class teleport { preInit = 1; recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_teleport: NO_CATEGORY { displayName = "Jib Teleport"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_teleport_module: Module_F {
        isGlobal=1; // All machines (not JIP)
        curatorCanAttach=1;
        category = "jib_teleport";
    };
    class jib_teleport_moduleFrom: jib_teleport_module {
        scopeCurator=2;
        displayName = "Teleport From";
        function = "jib_teleport_moduleFrom";
    };
    class jib_teleport_moduleTo: jib_teleport_module {
        scopeCurator=2;
        displayName = "Teleport To";
        function = "jib_teleport_moduleTo";
    };
    class jib_teleport_moduleSelf: jib_teleport_module {
        scopeCurator=2;
        displayName = "Teleport Self";
        function = "jib_teleport_moduleSelf";
    };
    class jib_teleport_moduleAll: jib_teleport_module {
        scopeCurator=2;
        displayName = "Teleport All";
        function = "jib_teleport_moduleAll";
    };
};
