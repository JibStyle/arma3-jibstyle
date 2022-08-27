class CfgPatches {
    class jib_respawn {
        name = "Jib Respawn";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_respawn {
        class jib_respawn {
            file = "x\jib\addons\respawn";
            class postInit { recompile = 1; postInit = 1; };
        };
    };
};
