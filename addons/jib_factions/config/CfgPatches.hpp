class CfgPatches {
    class jib_factions {
        name = "JibStyle Factions";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {
            "tfar_handhelds",
            "cTab",
            "ace_common",
            "rhsusf_main",
        };
        units[] = {
            #include "jib_ai_blu_f\CfgUnits.hpp"
            #include "jib_ai_blu_t_f\CfgUnits.hpp"
            #include "jib_player_blu_f\CfgUnits.hpp"
        };
        weapons[] = {};
    };
};
