// Create logic to force addon upon a mission load
if (not isServer) exitWith { "Not server" };
if (not isNil "jib_modules_token") exitWith { "Aready initialized" };
jib_modules_token = createGroup sideLogic createUnit [
    "jib_modules_token",
    [500,500,0],
    [],
    0,
    "NONE"
];
