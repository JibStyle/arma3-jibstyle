class CfgPatches {
    class jib_alive {
        name = "Jib ALiVE";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_alive_moduleRegisterEnable",
            "jib_alive_moduleRegisterDisable",
            "jib_alive_moduleOpcomDisable",
            "jib_alive_moduleOpcomEnable",
            "jib_alive_moduleProfileDisable",
            "jib_alive_moduleProfileEnable",
        };
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_alive {
        class jib_alive {
            file = "x\jib\addons\alive";
            class alive {recompile = 1; preInit = 1;};
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_alive: NO_CATEGORY { displayName = "Jib ALiVE"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_alive_module: Module_F {
        isGlobal=1;
        curatorCanAttach=1;
        category = "jib_alive";
    };
    class jib_alive_moduleRegisterEnable: jib_alive_module {
        scopeCurator=2;
        displayName = "ALiVE Register Enable";
        function = "jib_alive_moduleRegisterEnable";
    };
    class jib_alive_moduleRegisterDisable: jib_alive_module {
        scopeCurator=2;
        displayName = "ALiVE Register Disable";
        function = "jib_alive_moduleRegisterDisable";
    };
    class jib_alive_moduleOpcomDisable: jib_alive_module {
        scopeCurator=2;
        displayName = "ALiVE OPCOM Disable";
        function = "jib_alive_moduleOpcomDisable";
    };
    class jib_alive_moduleOpcomEnable: jib_alive_module {
        scopeCurator=2;
        displayName = "ALiVE OPCOM Enable";
        function = "jib_alive_moduleOpcomEnable";
    };
    class jib_alive_moduleProfileDisable: jib_alive_module {
        scopeCurator=2;
        displayName = "ALiVE Profiles Disable";
        function = "jib_alive_moduleProfileDisable";
    };
    class jib_alive_moduleProfileEnable: jib_alive_module {
        scopeCurator=2;
        displayName = "ALiVE Profiles Enable";
        function = "jib_alive_moduleProfileEnable";
    };
};
