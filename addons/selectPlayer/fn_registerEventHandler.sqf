// Register event handler for when selecting player.
//
// Register handlers on server and they will be broadcast. Handlers
// accept no arguments. When selecting players, handlers run on the
// player's local machine.
if (!isServer) then {throw "Not server"};
params [
    ["_handler", {}, [{}]]
];
if (isNil "jib_selectPlayer_handlers") then {
    jib_selectPlayer_handlers = [];
};
jib_selectPlayer_handlers pushBack _handler;
publicVariable "jib_selectPlayer_handlers";
