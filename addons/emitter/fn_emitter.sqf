jib_emitter_deserialize_batch;
jib_emitter_deserialize_crate;
jib_emitter_deserialize_waypoint;
jib_emitter_serialize_batch;
jib_emitter_serialize_crate;
jib_emitter_serialize_waypoint;

jib_emitter_delay_condition = 1;
jib_emitter_debug = false;

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
    _logic setVariable ["jib_emitter__wp_enabled", _enabled];
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
    _logic setVariable ["jib_emitter__wp_enabled", _enabled];
    _logic;
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

// Emit one batch regardless of budget or enabled status
jib_emitter_single = {
    if (!canSuspend) then {throw "Cannot suspend!"};
    params [
        "_logic",
        ["_index", -1, [0]]
    ];
    private _emitter = selectRandom (
        [_logic] + synchronizedObjects _logic select {
            _x getVariable ["jib_emitter__type", ""] == "emitter"
        }
    );

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

// Set budget params for continuous emission
jib_emitter_budget = {
    params [
        "_emitter",
        ["_budget_units", 12],   // Max concurrent units
        ["_budget_vehicles", 2], // Max concurrent vehicles
        ["_period", 20],         // Time between emissions
        ["_tickets", 1e6]        // Num emissions until disable
    ];
    if (!isServer) exitWith {};
    _emitter setVariable ["jib_emitter__budget_units", _budget_units];
    _emitter setVariable ["jib_emitter__budget_vehicles", _budget_vehicles];
    _emitter setVariable ["jib_emitter__period", _period];
    _emitter setVariable ["jib_emitter__tickets", _tickets];
};

// Enable continuous emission with budget and period
jib_emitter_enable = {
    params ["_logic"];
    if (!isServer) exitWith {};
    terminate (_logic getVariable ["jib_emitter__script", scriptNull]);
    _logic setVariable [
        "jib_emitter__script",
        [_logic] spawn {
            params ["_logic"];
            private _emitters = [_logic] + synchronizedObjects _logic select {
                _x getVariable ["jib_emitter__type", ""] == "emitter"
            };
            while {true} do {
                if (
                    (
                        _logic getVariable ["jib_emitter__tickets", 1e6] > 0
                    ) && count flatten (
                        _emitters apply {[_x] call jib_emitter_get_units}
                    ) < _logic getVariable [
                        "jib_emitter__budget_units", 12
                    ] && count flatten (
                        _emitters apply {[_x] call jib_emitter_get_vehicles}
                    ) < _logic getVariable [
                        "jib_emitter__budget_vehicles", 2
                    ]
                ) then {
                    [selectRandom _emitters] call jib_emitter_single;
                    _logic setVariable [
                        "jib_emitter__tickets",
                        (_logic getVariable ["jib_emitter__tickets", 1e6]) - 1
                    ];
                } else {
                    if (jib_emitter_debug) then {
                        systemChat "Emitter over budget";
                    };
                };
                private _period =
                    _logic getVariable ["jib_emitter__period", 20];
                uiSleep random [0, _period, 2 * _period];
            };
        }
    ];
};

// Disable emitter eg. when overrun by enemies
jib_emitter_disable = {
    params ["_emitter"];
    if (!isServer) exitWith {};
    terminate (_emitter getVariable ["jib_emitter__script", scriptNull]);
};

// Delete emitted units
jib_emitter_cleanup = {
    params ["_logic"];
    private _delay = 1;
    if (!canSuspend) then {throw "Cannot suspend!"};
    [_logic] + synchronizedObjects _logic select {
        _x getVariable ["jib_emitter__type", ""] == "emitter"
    } apply {
        [_x] call jib_emitter_get_units apply {
            private _veh = vehicle _x;
            deleteVehicleCrew _veh;
            deleteVehicle _veh;
            uiSleep _delay;
        };
        [_x] call jib_emitter_get_vehicles apply {
            private _veh = _x;
            deleteVehicleCrew _veh;
            deleteVehicle _veh;
            uiSleep _delay;
        };
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
    _deserializedVehicles apply {
        _x setVariable ["jib_emitter__source", "emitter"]
    };
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
    _deserializedGroups apply {
        _x setVariable ["jib_emitter__source", "emitter"]
    };
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
    _deserializedUnits apply {
        _x setVariable ["jib_emitter__source", "emitter"]
    };
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
    _deserializedCrate setVariable ["jib_emitter__source", "emitter"];
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

// Get deserialized batches
jib_emitter_get_batches = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_batches", []
    ] select {
        _x params ["_vehicles", "_groups"];
        {alive _x} count _vehicles > 0
            || {{alive _x} count units _x > 0} count _groups > 0;
    };
};

// Get deserialized vehicles
jib_emitter_get_vehicles = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_vehicles", []
    ] select {alive _x && {alive _x} count crew _x > 0};
};

// Get deserialized groups
jib_emitter_get_groups = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_groups", []
    ] select {{alive _x} count units _x > 0};
};

// Get deserialized units
jib_emitter_get_units = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_units", []
    ] select {alive _x};
};

// Get deserialized crates
jib_emitter_get_crates = {
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
            && _x getVariable ["jib_emitter__wp_enabled", false]
            && !(_x in _blacklist)
    } apply {
        _synchronizedNodes pushBack _x;
        _synchronizedNodes pushBack (
            _x getVariable ["jib_emitter__weight", 1]
        );
    };
    _synchronizedNodes;
};
