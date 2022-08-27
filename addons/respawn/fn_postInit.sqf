// Declare respawn event handlers to register
if (!isServer) then {throw "Not server"};

// Respawn event handlers to install.
//
// Handlers take two params: unit and corpse. Same as BIS EH. We
// collect them all here so they can be reinstalled after certain
// events such as select player.
jib_respawn_handlers = [];

// (Re)Install respawn event handlers.
//
// Certain events like select player change the "player" object, and
// all registered event handlers on the old player are lost. Here we
// can resinstate them.
jib_respawn_installHandlers = {
    jib_respawn_handlers apply {
        player addEventHandler ["Respawn", _x];
    };
};

// Publish variables and functions
publicVariable "jib_respawn_handlers";
publicVariable "jib_respawn_installHandlers";
