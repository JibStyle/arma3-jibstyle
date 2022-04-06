// Teardown debug drawing
//
// NOTE: Local effect!
if (not hasInterface) exitWith { "No interface!" };
if (isNil "jib_debug_drawHandle") exitWith { "Already tore down!" };
removeMissionEventHandler ["Draw3D", jib_debug_drawHandle];
jib_debug_drawHandle = nil;
