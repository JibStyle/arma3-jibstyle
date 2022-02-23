class CfgPatches {
    class jib_zeus {
        name = "Jib Zeus";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_UI_F","A3_Data_F"};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_zeus {
        class jib_zeus {
            file = "x\jib\addons\zeus";
            class setup {
                recompile = 1;
            };
        };
    };
};
