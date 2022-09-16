class CfgPatches {
    class jib_random {
        name = "JibStyle Random";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_random_moduleChooseNumber",
            "jib_random_moduleChooseProbability",
            "jib_random_moduleBucket",
            "jib_random_moduleBucketArea",
        };
        weapons[] = {};
    };
};

class CfgFunctions {
    class jib_random {
        class jib_random {
            file = "x\jib\addons\random";
            class random { preInit = 1; recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_random: NO_CATEGORY { displayName = "Jib Random"; };
};

class CfgVehicles
{
    class Module_F;
    class jib_random_module: Module_F {
        isGlobal = 1; // All machines (not JIP)
        category = "jib_random";
    };
    class jib_random_moduleChooseNumber: jib_random_module {
        scope = 2; // 2: Eden, 1: Hidden (default)
        displayName = "Random Choose Number";
        function = "jib_random_moduleChooseNumber";
        class Arguments {
            class jib_random_moduleNumber {
                displayName = "Number of Buckets to Choose";
                description = "This many buckets will be chosen, and the objects associated with the rest will be deleted.";
                defaultValue = "1";
                typeName = "NUMBER";
            };
        };
        class ModuleDescription {
            description = "Sync bucket modules to choose from.";
        };
    };
    class jib_random_moduleChooseProbability: jib_random_module {
        scope = 2; // 2: Eden, 1: Hidden (default)
        displayName = "Random Choose Probability";
        function = "jib_random_moduleChooseProbability";
        class Arguments {
            class jib_random_moduleProbability {
                displayName = "Probability to Choose Each Bucket";
                description = "Each bucket will be chosen with this probabilily, and the objects associated with the rest will be deleted.";
                defaultValue = "0.5";
                typeName = "NUMBER";
            };
        };
        class ModuleDescription {
            description = "Sync bucket modules to choose from.";
        };
    };
    class jib_random_moduleBucket: jib_random_module {
        scope = 2; // 2: Eden, 1: Hidden (default)
        displayName = "Random Bucket";
        function = "jib_random_moduleBucket";
        class ModuleDescription {
            description = "Associate objects by syncing them to the module.";
        };
    };
    class jib_random_moduleBucketArea: jib_random_moduleBucket {
        scope = 2; // 2: Eden, 1: Hidden (default)
        displayName = "Random Bucket Area";
        function = "jib_random_moduleBucketArea";
        canSetArea = 1;
        canSetAreaHeight = 0;
        canSetAreaShape = 1;
        class AttributeValues {
            size3[] = {5,5,-1};
            isRectangle = 0;
        };
        class ModuleDescription {
            description = "Associate objects by syncing or placing them in the module area.";
        };
    };
};
