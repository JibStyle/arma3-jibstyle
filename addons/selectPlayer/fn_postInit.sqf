// Declare handlers to run after selecting player
if (!isServer) then {throw "Not server"};

// Select player event handlers.
//
// Handlers take no arguments, and run on client machine of player who
// was selected.
jib_selectPlayer_handlers = [];

// Publish variables and functions
publicVariable "jib_selectPlayer_handlers";
