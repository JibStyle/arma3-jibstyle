class CfgPatches {
    class jib_hc {
        name = "Jib Modules";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_hc_promote",
            "jib_hc_demote",
            "jib_hc_add",
            "jib_hc_remove",
            "jib_hc_debug",
        };
    };
};
class CfgFunctions {
    class jib_hc {
        class jib_hc {
            file = "x\jib\addons\hc";
            class promote { recompile = 1; };
            class demote { recompile = 1; };
            class add { recompile = 1; };
            class remove { recompile = 1; };
            class debug { recompile = 1; };
        };
    };
};
class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_hc: NO_CATEGORY {
        displayName = "Jib High Command";
    };
};
class CfgVehicles
{
    class Module_F;
    class jib_hc_promote: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Promote";
        function = "jib_hc_fnc_promote";
    };
    class jib_hc_demote: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Demote";
        function = "jib_hc_fnc_demote";
    };
    class jib_hc_add: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Add to Last";
        function = "jib_hc_fnc_add";
    };
    class jib_hc_remove: Module_F {
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Remove";
        function = "jib_hc_fnc_remove";
    };
    class jib_hc_debug: Module_F {
        isGlobal=1;
        scopeCurator=2;
        curatorCanAttach=1;
        category = "jib_hc";
        displayName = "Print Debug Info";
        function = "jib_hc_fnc_debug";
    };
};
