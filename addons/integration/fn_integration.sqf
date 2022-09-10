// Integrate addon dependencies
if (!isServer) exitWith {};

// Define mission start handlers.
//
// TODO: Move this somewhere else.
jib_integration_missionStartHandlers = [];
jib_integration_missionStarted = {
    // Abort if in main menu.
    //
    // https://forums.bohemia.net/forums/topic/224307-solved-prevent-function-initialization-in-main-menu/
    if (allDisplays isEqualTo [findDisplay 0]) exitWith {};

    // Run handlers
    jib_integration_missionStartHandlers apply { [] call _x; };
};
publicVariable "jib_integration_missionStartHandlers";
publicVariable "jib_integration_missionStarted";

// Reset handlers
jib_integration_missionStartHandlers = [];
jib_respawn_handlers = [];
jib_selectPlayer_handlers = [];

// Install respawn handlers
jib_integration_missionStartHandlers pushBack {
    [] call jib_respawn_installHandlers;
};
jib_selectPlayer_handlers pushBack {
    [] call jib_respawn_installHandlers;
};

// Register earplug event handlers
// jib_integration_missionStartHandlers pushBack {
//     [] call jib_earplugs_addActions;
//     [false] call jib_earplugs_disable;
// };
// jib_respawn_handlers pushBack {
//     [] call jib_earplugs_addActions;
//     [false] call jib_earplugs_disable;
// };
// jib_selectPlayer_handlers pushBack {
//     [] call jib_earplugs_addActions;
//     [false] call jib_earplugs_disable;
// };

// Register HC transport event handlers
jib_integration_missionStartHandlers pushBack {
    [] call HC_Trans_addAction;
};
jib_respawn_handlers pushBack {
    [] call HC_Trans_addAction;
};
jib_selectPlayer_handlers pushBack {
    [] call HC_Trans_addAction;
};

// Publish event handler lists
publicVariable "jib_integration_missionStartHandlers";
publicVariable "jib_respawn_handlers";
publicVariable "jib_selectPlayer_handlers";

// Run the mission start handlers
//
// TODO: Move this somewhere else.
[] remoteExec ["jib_integration_missionStarted", 0, true];

jib_ai_moduleValidate = jib_module_validate;
jib_debug_moduleValidate = jib_module_validate;
jib_hc_moduleValidate = jib_module_validate;
jib_misc_moduleValidate = jib_module_validate;
jib_objective_moduleValidate = jib_module_validate;
jib_selectPlayer_moduleValidate = jib_module_validate;
jib_support_moduleValidate = jib_module_validate;
jib_sync_moduleValidate = jib_module_validate;
jib_teleport_moduleValidate = jib_module_validate;
jib_wp_moduleValidate = jib_module_validate;
jib_wp_paraIngress = jib_para_ingress;
jib_wp_paraUnload = jib_para_unload;
jib_wp_paraEgress = jib_para_egress;
publicVariable "jib_ai_moduleValidate";
publicVariable "jib_debug_moduleValidate";
publicVariable "jib_hc_moduleValidate";
publicVariable "jib_misc_moduleValidate";
publicVariable "jib_objective_moduleValidate";
publicVariable "jib_selectPlayer_moduleValidate";
publicVariable "jib_support_moduleValidate";
publicVariable "jib_sync_moduleValidate";
publicVariable "jib_teleport_moduleValidate";
publicVariable "jib_wp_moduleValidate";
publicVariable "jib_wp_paraIngress";
publicVariable "jib_wp_paraUnload";
publicVariable "jib_wp_paraEgress";
