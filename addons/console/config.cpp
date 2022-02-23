class CfgPatches {
    class my_console {
        name = "My Console";
        author = "JibStyle";
        requiredVersion = 1.60;
        requiredAddons[] = {"A3_UI_F","A3_Data_F"};
        units[] = {};
        weapons[] = {};
    };
};

// Must run on server and admin client
enableDebugConsole = 1; // SP, host, or admin
// enableTargetDebug = true;
