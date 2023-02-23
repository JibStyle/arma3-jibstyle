jib_garbage_debug = false;

jib_garbage__collectors = [
    [
        "vehicles", 50, 5, 10, 120, 1200,
        {
            vehicles select {
                if (count (crew _x arrayIntersect allPlayers) > 0) then {
                    _x setVariable ["jib_garbage__player", true];
                };
                _x getVariable ["jib_garbage__player", false] == false
                    && count fullCrew [_x, "", true] > 0
            }
        },
        {{alive _x} count crew _this == 0},
        {deleteVehicleCrew _this; deleteVehicle _this;}
    ],
    [
        "player vehicles", 50, 5, 10, 1200, 1e10,
        {vehicles select {_x getVariable ["jib_garbage__player", false]}},
        {{alive _x} count crew _this == 0},
        {deleteVehicleCrew _this; deleteVehicle _this;}
    ],
    [
        "crates", 50, 5, 10, 1200, 1e10,
        {entities "ReammoBox_F"},
        {isDamageAllowed _this},
        {deleteVehicle _this}
    ],
    [
        "dead bodies", 50, 10, 30, 120, 1200,
        {allDeadMen},
        {true},
        {deleteVehicle _this}
    ],
    [
        "dead body weapon", 50, 10, 30, 120, 1200,
        {entities "WeaponHolderSimulated"},
        {true},
        {deleteVehicle _this}
    ],
    [
        "ground weapon holder", 50, 0, 30, 120, 1200,
        {8 allObjects 0 select {_x isKindOf "GroundWeaponHolder"}},
        {true},
        {deleteVehicle _this}
    ]
];
jib_garbage__period = 10;
jib_garbage__sentinel = 1e+010;

// Start garbage collector
jib_garbage_start = {
    if (!isServer) exitWith {};
    call jib_garbage_stop;

    jib_garbage__handle = [] spawn {
        while {true} do {
            call jib_garbage__cycle;
        };
    };
};

// Stop garbage collector
jib_garbage_stop = {
    terminate (
        missionNamespace getVariable ["jib_garbage__handle", scriptNull]
    );
};

// Include or exempt object from collection
jib_garbage_include = {
    params ["_object", "_include"];
    _object setVariable ["jib_garbage__include", _include];
};

jib_garbage__cycle = {
    jib_garbage__collectors apply {
        _x call jib_garbage__collect;
        uiSleep (jib_garbage__period / count jib_garbage__collectors);
    };
};

jib_garbage__collect = {
    params [
        "_name", "_distance",
        "_count_min", "_count_max", "_ttl_min", "_ttl_max",
        "_all_fn", "_collectible", "_dispose"
    ];
    private _collection = [] call _all_fn;
    private _garbage = [];

    // Narrow to included
    _collection =
        _collection select {_x getVariable ["jib_garbage__include", true]};

    // Mark collection
    _collection apply {
        if (_x call _collectible) then {
            if (
                _x getVariable ["jib_garbage__start", jib_garbage__sentinel]
                    == jib_garbage__sentinel
            ) then {
                _x setVariable ["jib_garbage__start", time];
            };
        } else {
            _x setVariable ["jib_garbage__start", jib_garbage__sentinel];
        };
    };

    // Narrow to collectible
    _collection = _collection select {_x call _collectible};
    private _diag_collectible = count _collection;

    // Sort
    _collection = [
        _collection, [],
        {_x getVariable ["jib_garbage__start", jib_garbage__sentinel]}
    ] call BIS_fnc_sortBy;

    // Garbage after count max
    _collection select [0, count _collection - _count_max] apply {
        _garbage pushBack _x;
    };
    _collection = _collection select [
        count _collection - _count_max max 0, count _collection
    ];

    // Narrow by distance
    _collection = _collection select {
        [_x] call jib_garbage__playerDistance > _distance
    };

    // Narrow by time min
    _collection = _collection select {
        (_x getVariable ["jib_garbage__start", jib_garbage__sentinel])
            + _ttl_min < time
    };

    // Garbage after time max
    _collection = _collection select {
        if (
            (_x getVariable ["jib_garbage__start", jib_garbage__sentinel])
                + _ttl_max < time
        ) then {
            _garbage pushBack _x;
            false;
        } else {
            true;
        };
    };

    // Garbage after count min
    _collection select [0, count _collection - _count_min] apply {
        _garbage pushBack _x;
    };
    private _diag_garbage = count _garbage;

    // Dispose
    _garbage apply {_x call _dispose};

    // Log
    if (jib_garbage_debug) then {
        systemChat format [
            "jib_garbage: %1", [_name, _diag_collectible, _diag_garbage]
        ];
    };

    // Return result
    [_diag_collectible, _diag_garbage];
};

jib_garbage__playerDistance = {
    params ["_object"];
    private _nearestPlayer = objNull;
    allPlayers apply {
        if (
            _x distance _object < _nearestPlayer distance _object
        ) then {
            _nearestPlayer = _x;
        };
    };
    _nearestPlayer distance _object;
};

jib_garbage__performance = {
    jib_garbage__collectors apply {
        diag_codePerformance [
            {_this # 0 call jib_garbage__collect}, [_x]
        ] # 0;
    };
};
