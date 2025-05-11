class CfgPatches {
    class jib_garrison {
        name = "JibStyle Garrison";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_garrison {
        class jib_garrison {
            file = "x\jib\addons\garrison";
            class garrison {recompile = 1; preInit = 1;};
            class garrisonArea { recompile = 1; };
            class chooseSlots { recompile = 1; };
            class indexBuilding { recompile = 1; };
        };
    };
};
