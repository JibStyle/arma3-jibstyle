class CfgPatches {
    class jib_module {
        name = "Jib Module";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_module_example",
            "jib_module_token",
        };
    };
};

class CfgFunctions {
    class jib_module {
        class jib_module {
            file = "x\jib\addons\module";
            class module { preInit = 1; recompile = 1; };
            class tokenInit { recompile = 1; preInit = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_module: NO_CATEGORY { displayName = "Jib Module"; };
    class jib_token: NO_CATEGORY { displayName = "Jib Token"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_module_moduleExample: Module_F {
        scope = 2; // 2: Eden, 1: Hidden (default)
        scopeCurator = 2;
        isGlobal = 1; // 0: Server (default), 1: All, 2: All + JIP
        category = "jib_module";
        displayName = "Module Example";
        function = "jib_module_moduleExample";
        class Arguments {
            class jib_module_exampleFoo {
                displayName = "Foo";
                description = "Example argument.";
                defaultValue = "jib default";
                type="ArgTypeTEXT";
            };
        };
    };
    class jib_module_token: Module_F {
        scope=2;
        displayName = "Token";
        category = "jib_token";
    };
};
