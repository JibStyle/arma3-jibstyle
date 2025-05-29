class CfgPatches {
    class jib_composition {
        name = "JibStyle Composition";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_composition {
        class jib_composition {
            file = "x\jib\addons\composition";
            class composition {recompile = 1; preInit = 1;};
        };
    };
};
