[] call jib_debug_fnc_drawSetup;
if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_debug_moduleValidate = {};

// Register object for drawing
//
// NOTE: Local effect!
jib_debug_drawAdd = {
    params [
        "_object" // Object to register
    ];
    if (not hasInterface) exitWith { "No interface!" };
    if (isNil "jib_debug_drawObjects") then {
        jib_debug_drawObjects = [];
    };
    if (_object in jib_debug_drawObjects) exitWith { "Already added!" };
    jib_debug_drawObjects pushBack _object;
};

// Unregister object for drawing
//
// NOTE: Local effect!
jib_debug_drawRemove = {
    params [
        "_object" // Object to unregister
    ];
    if (not hasInterface) exitWith { "No interface!" };
    jib_debug_drawObjects = jib_debug_drawObjects - [_object];
};

// Setup debug drawing
//
// NOTE: Local effect!
jib_debug_drawSetup = {
    if (not hasInterface) exitWith { "No interface!" };
    if (not isNil "jib_debug_drawHandle") then {
        [] call jib_debug_fnc_drawTeardown;
    };
    jib_debug_drawHandle = addMissionEventHandler [
        "Draw3D",
        {
            if (isNil "jib_debug_drawObjects") exitWith {};
            {
                private _color = [0,1,0,.5];
                private _offset = 2; // Additional height
                private _shadow = true;
                private _textSize = .05;

                drawIcon3D [
                    "",
                    _color,
                    ASLToAGL getPosASLVisual _x vectorAdd [
                        0,
                        0,
                        boundingBox _x # 1 # 2 + _offset
                    ],
                    0,
                    0,
                    0,
                    _x getVariable ["jib_debug_drawText", ""],
                    _shadow,
                    _textSize
                ];
            } forEach jib_debug_drawObjects;
        }
    ];
};

// Teardown debug drawing
//
// NOTE: Local effect!
jib_debug_drawTeardown = {
    if (not hasInterface) exitWith { "No interface!" };
    if (isNil "jib_debug_drawHandle") exitWith { "Already tore down!" };
    removeMissionEventHandler ["Draw3D", jib_debug_drawHandle];
    jib_debug_drawHandle = nil;
};

// PRIVATE BELOW HERE

jib_debug_moduleCopyPositionASL = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            private _posASL = ATLToASL _posATL;
            jib = _posASL; // Special convenience var
            copyToClipboard str _posASL;
            systemChat format ["%1 copied and set to jib.", _posASL];
        },
        [],
        "local"
    ] call jib_debug_moduleValidate;
};

jib_debug_moduleCopyPositionATL = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib = _posATL; // Special convenience var
            copyToClipboard str _posATL;
            systemChat format ["%1 copied and set to jib.", _posATL];
        },
        [],
        "local"
    ] call jib_debug_moduleValidate;
};

jib_debug_moduleSelectEntity = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            jib = _attached; // Special convenience var
            systemChat format ["%1 set to jib.", _attached];
        },
        [],
        "local"
    ] call jib_debug_moduleValidate;
};

publicVariable "jib_debug_moduleValidate";
publicVariable "jib_debug_moduleCopyPositionASL";
publicVariable "jib_debug_moduleCopyPositionATL";
publicVariable "jib_debug_moduleSelectEntity";
