class CfgPatches {
    class jib_teleport {
        name = "Jib Teleport";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_teleport {
        class jib_teleport {
            file = "x\jib\addons\teleport";
            class teleport { recompile = 1; };
        };
    };
};
