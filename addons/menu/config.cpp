class CfgPatches {
    class jib_menu {
        name = "Jib Menu";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {};
        units[] = {};
    };
};

class CfgFunctions {
    class jib_menu {
        class jib_menu {
            file = "x\jib\addons\menu";
            class menu { recompile = 1; preInit = 1; };
        };
    };
};

class CfgCommunicationMenu {
    class jib_menu_admin {
        text = "Admin Menu";
        submenu = "#USER:jib_menu_admin";
        // icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
    };
    class jib_menu_group {
        text = "Group Menu";
        submenu = "#USER:jib_menu_group";
        // icon = "\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa";
    };
};
