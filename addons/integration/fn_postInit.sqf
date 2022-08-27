// Integrate addon dependencies
if (!isServer) exitWith {};

// Define mission start handlers.
//
// TODO: Move this somewhere else.
jib_integration_missionStartHandlers = [];
jib_integration_missionStarted = {
    jib_integration_missionStartHandlers apply { [] call _x; };
};
publicVariable "jib_integration_missionStartHandlers";
publicVariable "jib_integration_missionStarted";

// Reset handlers
jib_integration_missionStartHandlers = [];
jib_respawn_handlers = [];
jib_selectPlayer_handlers = [];

// Install respawn handlers
jib_integration_missionStartHandlers pushBack jib_respawn_installHandlers;
jib_selectPlayer_handlers pushBack jib_respawn_installHandlers;

// Register earplug event handlers
jib_integration_missionStartHandlers pushBack jib_earplugs_addActions;
jib_integration_missionStartHandlers pushBack jib_earplugs_disable;
jib_respawn_handlers pushBack jib_earplugs_addActions;
jib_respawn_handlers pushBack jib_earplugs_disable;
jib_selectPlayer_handlers pushBack jib_earplugs_addActions;
jib_selectPlayer_handlers pushBack jib_earplugs_disable;

// Register HC transport event handlers
jib_integration_missionStartHandlers pushBack HC_Trans_addAction;
jib_respawn_handlers pushBack HC_Trans_addAction;
jib_selectPlayer_handlers pushBack HC_Trans_addAction;

// Publish event handler lists
publicVariable "jib_integration_missionStartHandlers";
publicVariable "jib_respawn_handlers";
publicVariable "jib_selectPlayer_handlers";

// Run the mission start handlers
//
// TODO: Move this somewhere else.
[] remoteExec ["jib_integration_missionStarted", 0, true];
