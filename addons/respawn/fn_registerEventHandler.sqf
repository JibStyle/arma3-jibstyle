// Register respawn event handler for all players
//
// Handler takes two params: unit and corpse. Same as BIS EH.
params [
    [
        "_handler",
        {
            params ["_unit", "_corpse"];
        },
        [{}]
    ]
];
[[_handler], {
    params ["_handler"];
    player addEventHandler ["Respawn", _handler];
}] remoteExec ["spawn", 0];
