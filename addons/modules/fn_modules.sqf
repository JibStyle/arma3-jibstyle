if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Check if activated and local. Get attached entity. Inner code run
// on specified locality machine. If inner code throws an exception
// string, it is shown as curator feedback message.
jib_modules_validate = {
    params [
        "_moduleParams",              // Module_F function params
        [
            "_code",                  // Run if validation success
            {
                params [
                    "_entity", // Synced entity or objNull
                    "_client"  // Owner of logic
                ];
            },
            [{}]
        ],
        ["_locality", "server", [""]] // "server" or "local"
    ];
    _moduleParams params ["_logic", "", "_isActivated"];

    // Validate activation and locality
    if (not _isActivated) exitWith {};
    if (not local _logic) exitWith {};

    // Get synced entity
    //
    // NOTE: Only reliable on client where logic is local. Race
    // condition to propagate variable from curator client to server.
    private _entity = _logic getvariable [
        "bis_fnc_curatorAttachObject_object",
        objNull
    ];

    // Run inner code
    switch (_locality) do
    {
        case "server": {
            [[_entity, clientOwner, player, _code], {
                params ["_entity", "_client", "_player", "_code"];
                try {[_entity, _client, _player] call _code} catch {
                    [objNull, str _exception] remoteExec [
                        "BIS_fnc_showCuratorFeedbackMessage",
                        _client
                    ];
                };
            }] remoteExec ["spawn", 2];
        };
        case "local": {
            try {[_entity, clientOwner, player] call _code} catch {
                [
                    objNull,
                    str _exception
                ] call BIS_fnc_showCuratorFeedbackMessage;
            };
        };
        default {};
    };
    deleteVehicle _logic;
};

publicVariable "jib_modules_validate";
