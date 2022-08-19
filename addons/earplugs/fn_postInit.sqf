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
    ];
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
    ];
};
[] remoteExec ["jib_earplugs_addActions", 0];

// Broadcast functions and variables
jib_earplugs_publicVariable = {
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
};
[] call jib_earplugs_publicVariable;
