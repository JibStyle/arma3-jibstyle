class CfgPatches {
    class jib_modules {
        name = "Jib Modules";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_Modules_F"};
        units[] = {
            "jib_modules_00",
        };
    };
};

class CfgFunctions {
    class jib_modules {
        class jib_modules {
            file = "x\jib\addons\modules";
            class 00 { recompile = 1; };
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class jib_modules: NO_CATEGORY {
        displayName = "Jib Modules";
    };
};

class CfgVehicles
{
    class Logic;
    class Module_F: Logic {
        class AttributesBase {
            class Default;
            class Edit;              // Default edit box (i.e., text input field)
            class Combo;             // Default combo box (i.e., drop-down menu)
            class Checkbox;          // Default checkbox (returned value is Boolean)
            class CheckboxNumber;    // Default checkbox (returned value is Number)
            class ModuleDescription; // Module description
            class Units;             // Units on which the module is applied
        };
        class ModuleDescription {
            class AnyBrain;
        };
    };

    // Example modules
    class jib_modules_00: Module_F {
        scope = 2;
        scopeCurator=2;
        curatorCanAttach=1;
        displayName = "Module 00";
        //icon = "\jibTag_addonName\data\iconNuke_ca.paa";
        category = "jib_modules";
        function = "jib_modules_fnc_00";
        functionPriority = 1; // Lower first, default 0
        isGlobal = 1; // 0 server (default), 1 global, 2 JIP
        isTriggerActivated = 1; // 0 default
        isDisposable = 1;
        is3DEN = 0;
        // Menu displayed in Zeus
        //curatorInfoType = "RscDisplayAttributeModuleNuke";

        class Attributes: AttributesBase {
            class Foo: Combo {
                property = "jib_modules_00_foo";
                displayName = "Foo display name";
                tooltip = "Foo tooltip";
                typeName = "NUMBER"; // "NUMBER", "STRING" or "BOOL"
                defaultValue = "50"; // Expression returning number
                class Values {
                    class 50Mt  {name = "50 megatons";  value = 50;};
                    class 100Mt {name = "100 megatons"; value = 100;};
                };
            };
            class Bar: Edit {
                property = "jib_modules_00_bar";
                displayName = "Name";
                tooltip = "Name of the module";
                defaultValue = """Poop"""; // Expression returning string
            };
            class Units: Units {
                property = "jib_modules_00_units";
            };
            class ModuleDescription: ModuleDescription {};
        };
        class ModuleDescription: ModuleDescription {
            position = 1;
            description = "Short module description"; // Structured text
        };
    };
};
