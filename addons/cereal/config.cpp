class CfgPatches {
    class jib_cereal {
        name = "JibStyle Cereal";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_cereal {
        class jib_cereal {
            file = "x\jib\addons\cereal";
            class cereal { recompile = 1; preInit = 1; };
        };
    };
};
