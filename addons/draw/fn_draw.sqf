if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_draw_moduleValidate = {};

// Setup clients at mission start
jib_draw_missionStart = {
    if (!isServer) then {throw "Not server!"};
    // [] remoteExec ["jib_draw_setup", 0, true];
};

// Register object for drawing
jib_draw_add = {
    params [
        "_object",           // Object to register
        ["_text", "", [""]], // Text to draw
        ["_lines", [], [[]]] // Lines to draw
    ];
    if (!isServer) then {throw "Not server!"};

    _object setVariable ["jib_draw_text", _text, true];
    _object setVariable ["jib_draw_lines", _lines, true];

    if (_object in jib_draw_objects) exitWith { "Already added!" };
    jib_draw_objects pushBack _object;
    publicVariable "jib_draw_objects";
};

// Unregister object for drawing
jib_draw_remove = {
    params [
        "_object" // Object to unregister
    ];
    if (!isServer) then {throw "Not server!"};
    jib_draw_objects = jib_draw_objects - [_object];
    publicVariable "jib_draw_objects";
};

// PRIVATE

// Registered objects
jib_draw_objects = [];

// Setup draw drawing
//
// NOTE: Local effect!
jib_draw_setup = {
    if (not hasInterface) exitWith { "No interface!" };
    [] call jib_draw_teardown;
    jib_draw_handle = addMissionEventHandler [
        "Draw3D",
        {
            if (isNil "jib_draw_objects") exitWith {};
            jib_draw_objects apply {
                private _object = _x;
                private _text =
                    _object getVariable ["jib_draw_text", ""];
                if (_text != "") then {
                    private _color = [0,1,0,.5];
                    private _offset = 2; // Additional height
                    private _shadow = true;
                    private _textSize = .05;

                    drawIcon3D [
                        "",
                        _color,
                        ASLToAGL getPosASLVisual _object vectorAdd [
                            0,
                            0,
                            boundingBox _object # 1 # 2 + _offset
                        ],
                        0,
                        0,
                        0,
                        _text,
                        _shadow,
                        _textSize
                    ];
                };

                private _lines =
                    _object getVariable ["jib_draw_lines", []];
                if (count _lines > 0) then {
                    _lines apply {
                        _x params ["_other", "_color", "_text"];
                        private _shadow = true;
                        private _textSize = .05;
                        private _interpolation = .75;

                        if (isNull _other) then {continue};

                        private _start = eyePos _object;
                        private _finish = aimPos _other;
                        private _middle = [
                            _start # 0 * (1 - _interpolation)
                                + _finish # 0 * _interpolation,
                            _start # 1 * (1 - _interpolation)
                                + _finish # 1 * _interpolation,
                            _start # 2 * (1 - _interpolation)
                                + _finish # 2 * _interpolation
                        ];

                        drawLine3D [
                            ASLToAGL _start,
                            ASLToAGL _finish,
                            _color
                        ];

                        drawIcon3D [
                            "",
                            _color,
                            ASLToAGL _middle,
                            0,
                            0,
                            0,
                            _text,
                            _shadow,
                            _textSize,
                            "PuristaBold",
                            "center",
                            false,
                            0,
                            -.0125
                        ];
                    };
                };
            };
        }
    ];
};

// Teardown draw drawing
//
// NOTE: Local effect!
jib_draw_teardown = {
    if (not hasInterface) exitWith { "No interface!" };
    if (isNil "jib_draw_handle") exitWith { "Already tore down!" };
    removeMissionEventHandler ["Draw3D", jib_draw_handle];
    jib_draw_handle = nil;
};

// Setup local
jib_draw_moduleSetupLocal = {
    [
        _this,
        {[] call jib_draw_setup;},
        [],
        "local"
    ] call jib_draw_moduleValidate;
};

// Teardown local
jib_draw_moduleTeardownLocal = {
    [
        _this,
        {[] call jib_draw_teardown;},
        [],
        "local"
    ] call jib_draw_moduleValidate;
};

// Setup global
jib_draw_moduleSetupGlobal = {
    [
        _this,
        {[] remoteExec ["jib_draw_setup", 0, true];}
    ] call jib_draw_moduleValidate;
};

// Teardown global
jib_draw_moduleTeardownGlobal = {
    [
        _this,
        {[] remoteExec ["jib_draw_teardown", 0, true];}
    ] call jib_draw_moduleValidate;
};

// Public variable
publicVariable "jib_draw_missionStart";
publicVariable "jib_draw_setup";
publicVariable "jib_draw_teardown";
publicVariable "jib_draw_add";
publicVariable "jib_draw_remove";
publicVariable "jib_draw_objects";
publicVariable "jib_draw_moduleValidate";
publicVariable "jib_draw_moduleSetupLocal";
publicVariable "jib_draw_moduleTeardownLocal";
publicVariable "jib_draw_moduleSetupGlobal";
publicVariable "jib_draw_moduleTeardownGlobal";
