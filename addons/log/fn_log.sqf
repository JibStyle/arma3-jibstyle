if (!isServer) exitWith {};

// True to log to systemChat also
jib_log_debug = false;

// Tag to identify logs in RPT
jib_log_tag = "JIB_LOG";

// Log a message.
//
// If target >= 0, dispatch log to remoteExec target.
jib_log = {
    params [
        "_message",          // Formatted message
        ["_target", -1, [0]] // remoteExec target (optional)
    ];

    if (_target >= 0) then {
        [
            format [
                "%1 (%2): %3",
                jib_log_tag,
                clientOwner,
                _message
            ]
        ] remoteExec ["jib_log_common", _target];
    } else {
        [
            format [
                "%1: %2",
                jib_log_tag,
                _message
            ]
        ] call jib_log_common;
    };
};

// PRIVATE

jib_log_common = {
    params ["_message"];

    diag_log _message;

    if (jib_log_debug) then {
        systemChat _message;
    };
};

publicVariable "jib_log";
publicVariable "jib_log_debug";
publicVariable "jib_log_common";
publicVariable "jib_log_tag";
