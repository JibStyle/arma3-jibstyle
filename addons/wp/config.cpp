class CfgPatches {
    class jib_wp {
        name = "Jib Waypoints";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_wp {
        class jib_wp {
            file = "x\jib\addons\wp";
            class guard { recompile = 1; };
        };
    };
};
