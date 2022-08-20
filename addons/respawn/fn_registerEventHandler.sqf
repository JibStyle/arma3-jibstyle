// Register respawn event handler for all players
//
// Handler takes two params: unit and corpse. Same as BIS EH. Register
// on server, and it will be broadcast to all clients.
if (!isServer) then {throw "Not server"};
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
