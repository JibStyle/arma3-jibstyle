// Simple earplugs feature.
//
// This function defines and broadcasts other functions. Run on
// server.
if (!isServer) exitWith {};

// Config
jib_earplugs_enableTitle = "Enable Earplugs";
jib_earplugs_disableTitle = "Disable Earplugs";
jib_earplugs_delay = 1.0;
jib_earplugs_volume = 0.2;
jib_earplugs_sound = "FD_Timer_F";
jib_earplugs_priority = 1.5;
jib_earplugs_enabled = false;
jib_earplugs_actionEnableID = "jib_earplugs_actionEnableID";
jib_earplugs_actionDisableID = "jib_earplugs_actionDisableID";

// Put in earplugs
jib_earplugs_enable = {
    jib_earplugs_delay fadeSound jib_earplugs_volume;
    jib_earplugs_enabled = true;
    player say jib_earplugs_sound;
    systemChat "Earplugs ON";
};

// Take out earplugs
jib_earplugs_disable = {
    jib_earplugs_delay fadeSound 1.0;
    jib_earplugs_enabled = false;
    player say jib_earplugs_sound;
    systemChat "Earplugs OFF";
};

// Add actions to player.
//
// NOTE: Must be called again after respawn or select player.
jib_earplugs_addActions = {
    private _actionEnableID =
        player getVariable [jib_earplugs_actionEnableID, -1];
    if (_actionEnableID > -1) then { player removeAction _actionEnableID; };
    player setVariable [
        jib_earplugs_actionEnableID,
        player addAction [
            jib_earplugs_enableTitle,
            jib_earplugs_enable,
            [],
            jib_earplugs_priority,
            false,
            true,
            "",
            "_target == _this && jib_earplugs_enabled == false",
            -1,
            false
        ]
    ];

    private _actionDisableID =
        player getVariable [jib_earplugs_actionDisableID, -1];
    if (_actionDisableID > -1) then { player removeAction _actionDisableID; };
    player setVariable [
        jib_earplugs_actionDisableID,
        player addAction [
            jib_earplugs_disableTitle,
            jib_earplugs_disable,
            [],
            jib_earplugs_priority,
            false,
            true,
            "",
            "_target == _this && jib_earplugs_enabled == true",
            -1,
            false
        ]
    ];
};

// Broadcast functions and variables
publicVariable "jib_earplugs_enableTitle";
publicVariable "jib_earplugs_disableTitle";
publicVariable "jib_earplugs_delay";
publicVariable "jib_earplugs_volume";
publicVariable "jib_earplugs_sound";
publicVariable "jib_earplugs_priority";
publicVariable "jib_earplugs_enabled";
publicVariable "jib_earplugs_enable";
publicVariable "jib_earplugs_disable";
publicVariable "jib_earplugs_addActions";
publicVariable "jib_earplugs_actionEnableID";
publicVariable "jib_earplugs_actionDisableID";
