// Register object for drawing
//
// NOTE: Local effect!
params [
    "_object" // Object to register
];
if (not hasInterface) exitWith { "No interface!" };
if (isNil "jib_debug_drawObjects") then {
    jib_debug_drawObjects = [];
};
if (_object in jib_debug_drawObjects) exitWith { "Already added!" };
jib_debug_drawObjects pushBack _object;
