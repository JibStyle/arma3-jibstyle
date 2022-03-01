class CfgPatches {
    class jib_hc {
        name = "Jib High Command";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
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
