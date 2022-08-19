// Integrate addon dependencies

// Register earplug event handlers
[jib_earplugs_addActions] call jib_selectPlayer_fnc_registerEventHandler;
[{
    [] call jib_earplugs_addActions;
    [] call jib_earplugs_disable;
}] call jib_respawn_fnc_registerEventHandler;

// Register HC transport event handlers
//
// NOTE: They don't work server side so need to check for mod
// installation.
jib_integration_installed = true;
[{
    if (!isNil "jib_integration_installed") then {
        [] call HC_Trans_addAction;
    };
}] call jib_selectPlayer_fnc_registerEventHandler;
[{
    if (!isNil "jib_integration_installed") then {
        [] call HC_Trans_addAction;
    };
}] call jib_respawn_fnc_registerEventHandler;
