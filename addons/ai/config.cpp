class CfgPatches {
    class jib_ai {
        name = "JibStyle AI";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_ai {
        class jib_ai {
            file = "x\jib\addons\ai";
            class initLaserGroupLead { recompile = 1; };
        };
    };
};
