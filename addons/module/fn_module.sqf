if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Validation occurs on machine where logic is local. Ensures
// activation and gets attached entity. Inner code dispatched to
// specified machine. If inner code throws exception, it dispatches
// display to machine where logic is local.
//
// NOTE: Attributes of logic such as client owner may not be synced
// over network when inner code runs remotely. More reliable to
// explicitly pass such attributes via args.
jib_module_validate = {
    params [
        "_moduleParams",               // Module_F function params
        [
            "_code",                   // Run if validation success
            {
                params [
                    "_posATL",       // Logic position ATL
                    "_attached",     // Attached entity or objNull
                    "_args",         // Passed through extra args
                    "_logic",        // Logic object
                    "_synchronized", // Synchronized objects
                    "_inArea"        // Objects in area module
                ];
            },
            [{}]
        ],
        ["_args", [], [[]]],           // Passed through to code
        ["_locality", "server", [""]], // "server" or "local"
        ["_delete", true, [true]]      // Auto delete module
    ];
    _moduleParams params ["_logic", "", "_isActivated"];

    // Validate activation and locality
    if (not _isActivated) exitWith {};
    if (not local _logic) exitWith {};

    private _posATL = getPosATL _logic;

    // Get attached entity
    //
    // NOTE: Only reliable on client where logic is local. Race
    // condition to propagate variable from curator client to server.
    private _attached = _logic getvariable [
        "bis_fnc_curatorAttachObject_object",
        objNull
    ];

    // Get synchronized objects
    private _synchronized = synchronizedObjects _logic;

    // Get objects in area module
    private _inArea = [_logic] call jib_module_inArea;

    // Run inner code
    switch (_locality) do
    {
        case "server": {
            [
                [
                    clientOwner,
                    _logic,
                    _posATL,
                    _attached,
                    _synchronized,
                    _inArea,
                    _code,
                    _args
                ], {
                    params [
                        "_client",
                        "_logic",
                        "_posATL",
                        "_attached",
                        "_synchronized",
                        "_inArea",
                        "_code",
                        "_args"
                    ];
                    try {
                        [
                            _posATL,
                            _attached,
                            _args,
                            _logic,
                            _synchronized,
                            _inArea
                        ] call _code
                    } catch {
                        [objNull, str _exception] remoteExec [
                            "BIS_fnc_showCuratorFeedbackMessage",
                            _client
                        ];
                    };
                }
            ] remoteExec ["spawn", 2];
        };
        case "local": {
            try {
                [
                    _posATL,
                    _attached,
                    _args,
                    _logic,
                    _synchronized,
                    _inArea
                ] call _code
            } catch {
                [
                    objNull,
                    str _exception
                ] call BIS_fnc_showCuratorFeedbackMessage;
            };
        };
        default {};
    };
    if (_delete) then {
        deleteVehicle _logic;
    };
};

// PRIVATE

// Get entities in logic area
jib_module_inArea = {
    params ["_logic"];

    private _area = [getPosATL _logic];
    _area append (
        // [a, b, rotation, rectangle, z]
        _logic getVariable ["objectArea", [0, 0, 0, false, -1]]
    );
    _area params ["", "_a", "_b"];

    // private _entities = (
    //     _logic nearEntities (_a max _b) * 1.42
    // ) inAreaArray _area select {
    //     _x != _logic;
    // };

    private _terrainObjects = nearestTerrainObjects [
        _logic,
        [],
        (_a max _b) * 1.42,
        false
    ] inAreaArray _area select {
        _x != _logic;
    };

    private _objects = (
        _logic nearObjects (_a max _b) * 1.42
    ) inAreaArray _area select {
        _x != _logic;
    };

    _objects select { _x in _terrainObjects == false };
};

jib_module_moduleExample = {
    params ["_logic", "_units", "_isActivated"];
    if (!_isActivated) exitWith {};
    jib_module_exampleFoo =
        _logic getVariable ["jib_module_exampleFoo", objNull];
};

publicVariable "jib_module_validate";
publicVariable "jib_module_inArea";
