class CfgPatches {
    class jib_eden {
        name = "Jib Eden";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_eden {
        class jib_eden {
            file = "x\jib\addons\eden";
            class eden { preInit = 1; }; // recompile not work in eden
        };
    };
};
