// Unregister object for drawing
//
// NOTE: Local effect!
params [
    "_object" // Object to unregister
];
if (not hasInterface) exitWith { "No interface!" };
jib_debug_drawObjects = jib_debug_drawObjects - [_object];
