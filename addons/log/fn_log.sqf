if (!isServer) exitWith {};

// True to log to systemChat also
jib_log_debug = false;

// Tags to identify logs in RPT
jib_log_tagLocal = "JIB_LOG_LOCAL";
jib_log_tagTarget = "JIB_LOG_TARGET";
jib_log_tagServer = "JIB_LOG_SERVER";
jib_log_tagGlobal = "JIB_LOG_GLOBAL";

// Log a message.
//
// Type may be "local", "target", "server", or "global". For target,
// must provide destination client ID also.
jib_log = {
    params [
        "_message",                 // Formatted message
        ["_type", "local", [""]],   // Type of destination
        ["_destination", 1e11, [0]] // Destination client ID
    ];

    private _source = clientOwner;
    switch (_type) do
    {
        case "local": {
            [
                format [
                    "%1 (%2): %3",
                    jib_log_tagLocal,
                    _source,
                    _message
                ]
            ] call jib_log_common;
        };
        case "target": {
            [
                format [
                    "%1 (%2): %3",
                    jib_log_tagTarget,
                    _source,
                    _message
                ]
            ] remoteExec ["jib_log_common", _destination];
        };
        case "server": {
            [
                format [
                    "%1 (%2): %3",
                    jib_log_tagServer,
                    _source,
                    _message
                ]
            ] remoteExec ["jib_log_common", 2];
        };
        case "global": {
            [
                format [
                    "%1 (%2): %3",
                    jib_log_tagGlobal,
                    _source,
                    _message
                ]
            ] remoteExec ["jib_log_common", 0, true];
        };
        default {
            throw format ["Illegal log type: %1", _type];
        };
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
publicVariable "jib_log_tagLocal";
publicVariable "jib_log_tagTarget";
publicVariable "jib_log_tagServer";
publicVariable "jib_log_tagGlobal";
