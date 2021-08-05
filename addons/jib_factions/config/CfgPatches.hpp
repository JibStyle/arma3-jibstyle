class CfgPatches {
    class jib_factions {
        name = "JibStyle Factions";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {
            "tfar_handhelds",
            "cTab",
            "ace_common",
        };
        units[] = {
            #include "jib_blu_f\CfgUnits.hpp"
            #include "jib_blu_t_f\CfgUnits.hpp"
        };
        weapons[] = {};
    };
};
