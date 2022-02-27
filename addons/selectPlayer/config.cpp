class CfgPatches {
    class jib_selectPlayer {
        name = "Jib Select Player";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_selectPlayer {
        class jib_selectPlayer {
            file = "x\jib\addons\selectPlayer";
            class selectPlayer { recompile = 1; };
        };
    };
};
