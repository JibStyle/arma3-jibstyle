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
            class respawn { recompile = 1; preInit = 1; };
        };
    };
};
