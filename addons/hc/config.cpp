class CfgPatches {
    class jib_hc {
        name = "Jib High Command";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_hc_modulePromote",
            "jib_hc_moduleDemote",
            "jib_hc_moduleAdd",
            "jib_hc_moduleRemove",
            "jib_hc_moduleDebug",
        };
    };
};
class CfgFunctions {
    class jib_hc {
        class jib_hc {
            file = "x\jib\addons\hc";
            class hc { recompile = 1; preInit = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_hc: NO_CATEGORY { displayName = "Jib HC"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_hc_module: Module_F {
        isGlobal=1; // All machines (not JIP)
        curatorCanAttach=1;
        category = "jib_hc";
    };
    class jib_hc_modulePromote: jib_hc_module {
        scopeCurator=2;
        displayName = "HC Promote";
        function = "jib_hc_modulePromote";
    };
    class jib_hc_moduleDemote: jib_hc_module {
        scopeCurator=2;
        displayName = "HC Demote";
        function = "jib_hc_moduleDemote";
    };
    class jib_hc_moduleAdd: jib_hc_module {
        scopeCurator=2;
        displayName = "HC Add to Last";
        function = "jib_hc_moduleAdd";
    };
    class jib_hc_moduleRemove: jib_hc_module {
        scopeCurator=2;
        displayName = "HC Remove";
        function = "jib_hc_moduleRemove";
    };
    class jib_hc_moduleDebug: jib_hc_module {
        scopeCurator=2;
        displayName = "HC Print Debug Info";
        function = "jib_hc_moduleDebug";
    };
};
