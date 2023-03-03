jib_emitter_deserialize_batch;
jib_emitter_deserialize_crate;
jib_emitter_deserialize_waypoint;
jib_emitter_serialize_batch;
jib_emitter_serialize_crate;
jib_emitter_serialize_waypoint;

jib_emitter_delay_condition = 1;
jib_emitter_debug = true;

// Save waypoint data
jib_emitter_waypoint = {
    params [
        "_logic",
        ["_weight", 1, [0]],
        ["_radius", 0, [0]],
        ["_type", "MOVE", [""]],
        ["_formation", "NO CHANGE", [""]],
        ["_behaviour", "UNCHANGED", [""]],
        ["_combatMode", "NO CHANGE", [""]],
        ["_speed", "UNCHANGED", [""]],
        ["_timeout", [0, 0, 0], [[]]],
        ["_statements", ["true", ""], [[]]],
        ["_enabled", true, [false]]
    ];

    private _serializedWaypoint = [
        getPos _logic, // maybe unused
        _radius,
        _type,
        _formation,
        _behaviour,
        _combatMode,
        _speed,
        _timeout,
        _statements
    ] call jib_emitter_serialize_waypoint;

    _logic setVariable ["jib_emitter__type", "waypoint"];
    _logic setVariable ["jib_emitter__weight", _weight];
    _logic setVariable ["jib_emitter__enabled", _enabled];
    _logic setVariable [
        "jib_emitter__serialized_waypoint", _serializedWaypoint
    ];

    _serializedWaypoint;
};

// Register child path root
jib_emitter_child = {
    params [
        "_logic",
        ["_weight", 1, [0]],
        ["_enabled", true, [false]]
    ];

    _logic setVariable ["jib_emitter__type", "child"];
    _logic setVariable ["jib_emitter__weight", _weight];
    _logic setVariable ["jib_emitter__enabled", _enabled];
    _logic;
};

// Register allow fleeing for a single unit (1 - coward, 0 - no fleeing)
jib_emitter_fleeing = {
    params ["_unit", "_fleeing"];
    _unit setVariable ["jib_emitter__fleeing", _fleeing];
};

// Enable waypoint
jib_emitter_waypoint_enable = {
    params ["_waypoint"];
    _waypoint setVariable ["jib_emitter__enabled", true];
};

// Disable waypoint
jib_emitter_waypoint_disable = {
    params ["_waypoint"];
    _waypoint setVariable ["jib_emitter__enabled", false];
};

// Save batches and crates to emitter
jib_emitter_save = {
    params ["_emitter"];
    if (!isServer) exitWith {};

    private _batches = [];
    private _crates = [];

    synchronizedObjects _emitter apply {
        private _objectType = _x call BIS_fnc_objectType;
        switch true do
        {
            case (_objectType # 0 == "Soldier");
            case (_objectType # 0 == "Vehicle"): {
                private _vehicles =
                    [_x] + (
                        units group effectiveCommander _x apply {
                            assignedVehicle _x;
                        }
                    ) select {
                        (_x call BIS_fnc_objectType) # 0 == "Vehicle"
                    };
                _vehicles = _vehicles arrayIntersect _vehicles;
                private _groups = flatten [
                    group effectiveCommander _x,
                    _vehicles apply {crew _x apply {group _x}}
                ] select {not isNull _x};
                _groups = _groups arrayIntersect _groups;
                if (count _vehicles > 0 || count _groups > 0) then {
                    _batches pushBack [_vehicles, _groups];
                };
            };
            case (_objectType # 1 == "AmmoBox"): {
                _crates pushBack _x;
            };
            default {};
        };
    };

    private _serializedBatches =
        _batches apply {_x call jib_emitter_serialize_batch};
    private _serializedCrates =
        _crates apply {[_x] call jib_emitter_serialize_crate};

    _emitter setVariable ["jib_emitter__type", "emitter"];
    _emitter setVariable [
        "jib_emitter__serialized_batches", _serializedBatches
    ];
    _emitter setVariable [
        "jib_emitter__serialized_crates", _serializedCrates
    ];

    [_batches, _crates] spawn {
        params ["_batches", "_crates"];
        _batches apply {_x call jib_emitter__delete_batch};
        _crates apply {[_x] call jib_emitter__delete_crate};
    };

    [_batches, _crates, _serializedBatches, _serializedCrates];
};

// Emit continuously while under limit
jib_emitter_enable = {
    params [
        "_emitter",
        ["_emissionRandom",       [1, 1, 1],    [[]]],
        ["_concurrentBatches",    0,            [0]],
        ["_concurrentVehicles",   0,            [0]],
        ["_concurrentGroups",     0,            [0]],
        ["_concurrentUnits",      0,            [0]],
        ["_budgetBatches",        0,            [0]],
        ["_budgetVehicles",       0,            [0]],
        ["_budgetGroups",         0,            [0]],
        ["_budgetUnits",          0,            [0]],
        ["_cycleMemoryCoef",      0,            [0]],
        ["_cycleRandomCoef",      1,            [0]],
        ["_cycleRandom",          [10, 10, 10], [[]]],
        ["_cycleExponentialCoef", 1,            [0]],
        ["_cycleExponential",     0,            [0]],
        ["_cyclePowerCoef",       0,            [0]],
        ["_cyclePower",           0,            [0]],
        ["_cycleMin",             0,            [0]],
        ["_cycleMax",             10,           [0]]
    ];

    [_emitter] call jib_emitter_disable;
    _emitter setVariable [
        "jib_emitter__handle",
        [
            _emitter,              _emissionRandom,
            _concurrentBatches,    _concurrentVehicles,
            _concurrentGroups,     _concurrentUnits,
            _budgetBatches,        _budgetVehicles,
            _budgetGroups,         _budgetUnits,
            _cycleMemoryCoef,
            _cycleRandomCoef,      _cycleRandom,
            _cycleExponentialCoef, _cycleExponential,
            _cyclePowerCoef,       _cyclePower,
            _cycleMin,             _cycleMax
        ] spawn {
            params [
                "_emitter",              "_emissionRandom",
                "_concurrentBatches",    "_concurrentVehicles",
                "_concurrentGroups",     "_concurrentUnits",
                "_budgetBatches",        "_budgetVehicles",
                "_budgetGroups",         "_budgetUnits",
                "_cycleMemoryCoef",
                "_cycleRandomCoef",      "_cycleRandom",
                "_cycleExponentialCoef", "_cycleExponential",
                "_cyclePowerCoef",       "_cyclePower",
                "_cycleMin",             "_cycleMax"
            ];
            private _spentBatches = 0;
            private _spentVehicles = 0;
            private _spentGroups = 0;
            private _spentUnits = 0;
            private _cycleCount = 0;
            private _cycleMemory = 0;

            while {alive _emitter} do {
                if (
                    {
                        _x params ["_spent", "_budget"];
                        _budget > 0 && _spent >= _budget;
                    } count [
                        [_spentBatches, _budgetBatches],
                        [_spentVehicles, _budgetVehicles],
                        [_spentGroups, _budgetGroups],
                        [_spentUnits, _budgetUnits]
                    ] > 0
                ) exitWith {
                    if (jib_emitter_debug) then {
                        systemChat format [
                            "jib_emitter disable: %1", _emitter
                        ];
                    };
                    [_emitter] call jib_emitter_disable;
                };

                private _cycleStart = time;
                waitUntil {
                    uiSleep jib_emitter_delay_condition;
                    {
                        _x params ["_current", "_concurrent"];
                        _concurrent > 0
                            && (
                                count ([_emitter] call _current)
                                    >= _concurrent
                            );
                    } count [
                        [jib_emitter__get_batches, _concurrentBatches],
                        [jib_emitter__get_vehicles, _concurrentVehicles],
                        [jib_emitter__get_groups, _concurrentGroups],
                        [jib_emitter__get_units, _concurrentUnits]
                    ] == 0;
                };
                _cycleCount = _cycleCount + 1;
                _cycleMemory = time - _cycleStart;

                private _random = random _cycleRandom;
                private _cooldown = [
                    _cycleCount,
                    _cycleMemoryCoef, _cycleMemory,
                    _cycleRandomCoef, _random,
                    _cycleExponentialCoef, _cycleExponential,
                    _cyclePowerCoef, _cyclePower,
                    _cycleMin, _cycleMax
                ] call jib_emitter__cooldown;
                if (jib_emitter_debug) then {
                    private _data =
                        [
                            _emitter,
                            [
                                _spentBatches, _spentVehicles,
                                _spentGroups, _spentUnits
                            ],
                            [_cycleCount, _cycleMemory, _random, _cooldown]
                        ];
                    systemChat format ["jib_emitter cooldown: %1", _data];
                    _emitter setVariable ["jib_emitter_debug", _data];
                };

                sleep _cooldown;
                if (jib_emitter_debug) then {
                    systemChat format ["jib_emitter emit: %1", _emitter];
                };

                for "_i" from 0 to round random _emissionRandom - 1 do {
                    [_emitter] call jib_emitter_single params [
                        "_batches", "_vehicles", "_groups", "_units"
                    ];
                    _spentBatches = _spentBatches + count _batches;
                    _spentVehicles = _spentVehicles + count _vehicles;
                    _spentGroups = _spentGroups + count _groups;
                    _spentUnits = _spentUnits + count _units;
                };
            };
        }
    ];
};

// Emitter preset for infantry
jib_emitter_enable_infantry = {
    params ["_emitter"];
    [
        _emitter, [1, 1, 2], // emitter, emission
        0, 0, 0, 16,         // concurrent B, V, G, U
        0, 0, 0, 80,          // budget B, V, G, U
        1, 0, [0, 0, 0],     // coef mem, coef rand, rand
        1, 1.1, 0, 0, 0, 120 // coef exp, exp, coef pow, pow, min, max
    ] call jib_emitter_enable;
};

// Emitter preset for motorized
jib_emitter_enable_motorized = {
    params ["_emitter"];
    [
        _emitter, [1, 1, 1],
        0, 1, 0, 6,
        0, 6, 0, 0,
        1, 0, [10, 10, 10],
        1, 1.1, 0, 0, 0, 600
    ] call jib_emitter_enable;
};

// Emitter preset for air
jib_emitter_enable_air = {
    params ["_emitter"];
    [
        _emitter, [1, 1, 1],
        0, 1, 0, 6,
        0, 0, 0, 0,
        1, 0, [10, 10, 10],
        1, 1.1, 0, 0, 0, 600
    ] call jib_emitter_enable;
};

// Stop emitting continuously
jib_emitter_disable = {
    params ["_emitter"];
    terminate (_emitter getVariable ["jib_emitter__handle", scriptNull]);
};

// Emit one batch
jib_emitter_single = {
    if (!canSuspend) then {throw "Cannot suspend!"};
    params [
        "_emitter",
        ["_index", -1, [0]]
    ];

    private _serializedBatch = [
        _emitter getVariable [
            "jib_emitter__serialized_batches", []
        ], _index
    ] call jib_emitter__select;
    private _batch =
        [_serializedBatch] call jib_emitter_deserialize_batch;
    _batch params ["_vehicles", "_groups"];
    private _units = flatten (_groups apply {units _x});

    [_emitter, _batch] call jib_emitter__add_batch;
    [_emitter, _vehicles] call jib_emitter__add_vehicles;
    [_emitter, _groups] call jib_emitter__add_groups;
    [
        _emitter, flatten (_groups apply {units _x})
    ] call jib_emitter__add_units;

    private _paths =
        [_emitter, count _groups - 1] call jib_emitter__waypoint_search;
    if (count _paths < count _groups) then {
        throw format [
            "Num paths expected: %1, actual: %2",
            count _groups, count _paths
        ];
    };
    for "_i" from 0 to count _groups - 1 do {
        private _group = _groups # _i;
        private _path = _paths # _i;
        _path apply {
            [
                _group, _x getVariable [
                    "jib_emitter__serialized_waypoint", []
                ]
            ] call jib_emitter_deserialize_waypoint;
        };
    };

    [[_batch], _vehicles, _groups, _units];
};

// Emit one batch when all synced triggers activated
jib_emitter_trigger = {
    params ["_emitter"];
    if (!isServer) exitWith {};
    [_emitter] spawn {
        params ["_emitter"];
        waitUntil {
            uiSleep 1;
            {
                _x isKindOf "EmptyDetector" && !triggerActivated _x
            } count synchronizedObjects _emitter == 0;
        };
        [_emitter] call jib_emitter_single;
    };
};

// Emit one crate
jib_emitter_crate = {
    params [
        "_emitter",
        ["_index", -1, [0]]
    ];
    if (!canSuspend) then {throw "Cannot suspend!"};

    private _serializedCrate = [
        _emitter getVariable [
            "jib_emitter__serialized_crates", []
        ], _index
    ] call jib_emitter__select;
    private _crate =
        [_serializedCrate] call jib_emitter_deserialize_crate;
    [_emitter, _crate] call jib_emitter__add_crate;

    _crate;
};

// max(min((a1a2^x + b1x^b2) * (c1y + c2z), max), min)
jib_emitter__cooldown = {
    params [
        "_cycleCount",      // x:  Zero based cycle number
        "_cycleMemoryCoef", // c1: Last cycle time weight
        "_cycleMemory",     // y:  Last cycle time
        "_cooldownCoef",    // c2: Base cooldown weight
        "_cooldown",        // z:  Base cooldown
        "_exponentialCoef", // a1: Exponential base weight
        "_exponential",     // a2: Exponential base
        "_powerCoef",       // b1: Power weight
        "_power",           // b2: Power
        "_min",             // min
        "_max"              // max
    ];

    (
        (_exponentialCoef * _exponential ^ _cycleCount)
            + (_powerCoef * _cycleCount ^ _power)
    ) * (
        _cycleMemoryCoef * _cycleMemory + _cooldownCoef * _cooldown
    ) min _max max _min;
};

jib_emitter__add_batch = {
    params ["_emitter", "_deserializedBatch"];
    _emitter setVariable [
        "jib_emitter_deserialized_batches", (
            _emitter getVariable [
                "jib_emitter_deserialized_batches", []
            ]
        ) + [_deserializedBatch]
    ];
};

jib_emitter__add_vehicles = {
    params ["_emitter", "_deserializedVehicles"];
    _emitter setVariable [
        "jib_emitter_deserialized_vehicles", (
            _emitter getVariable [
                "jib_emitter_deserialized_vehicles", []
            ]
        ) + _deserializedVehicles
    ];
};

jib_emitter__add_groups = {
    params ["_emitter", "_deserializedGroups"];
    _emitter setVariable [
        "jib_emitter_deserialized_groups", (
            _emitter getVariable [
                "jib_emitter_deserialized_groups", []
            ]
        ) + _deserializedGroups
    ];
};

jib_emitter__add_units = {
    params ["_emitter", "_deserializedUnits"];
    _emitter setVariable [
        "jib_emitter_deserialized_units", (
            _emitter getVariable [
                "jib_emitter_deserialized_units", []
            ]
        ) + _deserializedUnits
    ];
};

jib_emitter__add_crate = {
    params ["_emitter", "_deserializedCrate"];
    _emitter setVariable [
        "jib_emitter_deserialized_crates", (
            _emitter getVariable [
                "jib_emitter_deserialized_crates", []
            ]
        ) + [_deserializedCrate]
    ];
};

jib_emitter__delete_batch = {
    params ["_vehicles", "_groups"];
    private _deleteVehicles = [] + _vehicles;
    _groups apply {
        units _x apply {_deleteVehicles pushBackUnique vehicle _x};
    };
    _deleteVehicles apply {
        deleteVehicleCrew _x;
        deleteVehicle _x;
    };
    _groups apply {deleteGroup _x};
};

jib_emitter__delete_crate = {
    params ["_crate"];
    deleteVehicle _crate;
};

jib_emitter__get_batches = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_batches", []
    ] select {
        _x params ["_vehicles", "_groups"];
        {alive _x} count _vehicles > 0
            || {{alive _x} count units _x > 0} count _groups > 0;
    };
};

jib_emitter__get_vehicles = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_vehicles", []
    ] select {alive _x && {alive _x} count crew _x > 0};
};

jib_emitter__get_groups = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_groups", []
    ] select {{alive _x} count units _x > 0};
};

jib_emitter__get_units = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_units", []
    ] select {alive _x};
};

jib_emitter__get_crates = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_crates", []
    ] select {alive _x};
};

jib_emitter__select = {
    params ["_list", ["_index", -1, [0]]];
    if (_index < 0) then {selectRandom _list} else {_list # _index};
};

jib_emitter__waypoint_search = {
    params [
        "_root",
        ["_numChildPaths", 0, [0]],
        ["_blacklist", [], [[]]]
    ];
    private _path = [];
    private _childPaths = [];

    private _relatives = [
        _root, _path + _blacklist, _childPaths, _numChildPaths
    ] call jib_emitter__waypoint_relatives;
    while {count _relatives != 0} do {
        private _neighbor = selectRandomWeighted _relatives;
        _path pushBack _neighbor;
        _relatives = [
            _neighbor, _path + _blacklist, _childPaths, _numChildPaths
        ] call jib_emitter__waypoint_relatives;
    };
    while {count _childPaths < _numChildPaths} do {
        _childPaths pushBack [];
    };
    [_path] + _childPaths;
};

jib_emitter__waypoint_relatives = {
    params ["_node", "_blacklist", "_childPaths", "_numChildPaths"];
    private _relatives = [
        _node, _blacklist, "waypoint"
    ] call jib_emitter__waypoint_neighbors;
    private _children = [
        _node, _blacklist, "child"
    ] call jib_emitter__waypoint_neighbors;
    if (count _children > 0) then {
        for "_i" from 0 to _numChildPaths - 1 do {
            private _child = selectRandomWeighted _children;
            _childPaths pushBack (
                (
                    [
                        _child, 0, _blacklist
                    ] call jib_emitter__waypoint_search
                ) # 0
            );
        };
        _numChildPaths = 0;
    };
    _relatives;
};

jib_emitter__waypoint_neighbors = {
    params ["_node", "_blacklist", "_type"];
    private _synchronizedNodes = [];
    synchronizedObjects _node select {
        _x getVariable ["jib_emitter__type", ""] == _type
            && _x getVariable ["jib_emitter__enabled", false]
            && !(_x in _blacklist)
    } apply {
        _synchronizedNodes pushBack _x;
        _synchronizedNodes pushBack (
            _x getVariable ["jib_emitter__weight", 1]
        );
    };
    _synchronizedNodes;
};
