class CfgPatches {
    class jib_logistics {
        name = "Jib Logistics";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_logistics {
        class jib_logistics {
            file = "x\jib\addons\logistics";
            class logistics { recompile = 1; preInit = 1; };
        };
    };
};

class CfgCommunicationMenu {
    class jib_logistics_unit_menu {
        text = "Unit Menu";
        submenu = "#USER:jib_logistics_unit_menu";
    };
    class jib_logistics_insert_menu {
        text = "Insert Menu";
        submenu = "#USER:jib_logistics_insert_menu";
    };
};
