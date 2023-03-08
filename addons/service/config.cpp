class CfgPatches {
    class jib_service {
        name = "Jib Service";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class jib_service {
        class jib_service {
            file = "x\jib\addons\service";
            class service {
                recompile = 1; preInit = 1;
            };
        };
    };
};
