jib_emitter_delay_physics = 0.3;
jib_emitter_delay_condition = 1;
jib_emitter_delay_emission = 10;
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
        ["_child", false, [false]],
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
    ];

    _logic setVariable [
        "jib_emitter_type",
        if (_child) then {"child"} else {"waypoint"}
    ];
    _logic setVariable ["jib_emitter_weight", _weight];
    _logic setVariable ["jib_emitter_enabled", _enabled];
    _logic setVariable [
        "jib_emitter_serialized_waypoint", _serializedWaypoint
    ];

    _serializedWaypoint;
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
        _batches apply {_x call jib_emitter__serialize_batch};
    private _serializedCrates =
        _crates apply {[_x] call jib_emitter__serialize_crate};

    _emitter setVariable ["jib_emitter_type", "emitter"];
    _emitter setVariable [
        "jib_emitter_serialized_batches", _serializedBatches
    ];
    _emitter setVariable [
        "jib_emitter_serialized_crates", _serializedCrates
    ];

    [_batches, _crates] spawn {
        params ["_batches", "_crates"];
        _batches apply {_x call jib_emitter__delete_batch};
        _crates apply {[_x] call jib_emitter__delete_crate};
    };

    [_batches, _crates, _serializedBatches, _serializedCrates];
};

// Set emission limits
jib_emitter_limit = {
    params [
        "_emitter",
        ["_maxBatches", 4, [0]],
        ["_maxVehicles", 4, [0]],
        ["_maxGroups", 8, [0]],
        ["_maxUnits", 48, [0]]
    ];

    _emitter setVariable ["jib_emitter_max_batches", _maxBatches];
    _emitter setVariable ["jib_emitter_max_vehicles", _maxVehicles];
    _emitter setVariable ["jib_emitter_max_groups", _maxGroups];
    _emitter setVariable ["jib_emitter_max_units", _maxUnits];
};

// Emit continuously while under limit
jib_emitter_enable = {
    params ["_emitter"];

    if (
        _emitter getVariable ["jib_emitter_enabled", false]
    ) exitWith {};
    _emitter setVariable ["jib_emitter_enabled", true];

    if (!canSuspend) then {throw "Cannot suspend!"};
    while {_emitter getVariable ["jib_emitter_enabled", false]} do {
        if (
            count (
                [_emitter] call jib_emitter__getDeserializedBatches
            ) < _emitter getVariable [
                "jib_emitter_max_batches", 0
            ] && count (
                [_emitter] call jib_emitter__getDeserializedVehicles
            ) < _emitter getVariable [
                "jib_emitter_max_vehicles", 0
            ] && count (
                [_emitter] call jib_emitter__getDeserializedGroups
            ) < _emitter getVariable [
                "jib_emitter_max_groups", 0
            ] && count (
                [_emitter] call jib_emitter__getDeserializedUnits
            ) < _emitter getVariable [
                "jib_emitter_max_units", 0
            ]
        ) then {
            [_emitter] call jib_emitter_single;
            uiSleep jib_emitter_delay_emission;
        };
        uiSleep jib_emitter_delay_condition;
    };
};

// Stop emitting continuously
jib_emitter_disable = {
    params ["_emitter"];
    _emitter setVariable ["jib_emitter_enabled", false];
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
            "jib_emitter_serialized_batches", []
        ], _index
    ] call jib_emitter__selectfromlist;
    private _batch =
        [_serializedBatch] call jib_emitter__deserialize_batch;

    _batch;
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
            "jib_emitter_serialized_crates", []
        ], _index
    ] call jib_emitter__selectfromlist;
    private _crate =
        [_serializedCrate] call jib_emitter__deserialize_crate;

    _crate;
};

jib_emitter__addDeserializedBatch = {
    params ["_emitter", "_deserializedBatch"];
    _emitter setVariable [
        "jib_emitter_deserialized_batches", (
            _emitter getVariable [
                "jib_emitter_deserialized_batches", []
            ]
        ) + [_deserializedBatch]
    ];
};

jib_emitter__addDeserializedVehicles = {
    params ["_emitter", "_deserializedVehicles"];
    _emitter setVariable [
        "jib_emitter_deserialized_vehicles", (
            _emitter getVariable [
                "jib_emitter_deserialized_vehicles", []
            ]
        ) + _deserializedVehicles
    ];
};

jib_emitter__addDeserializedGroups = {
    params ["_emitter", "_deserializedGroups"];
    _emitter setVariable [
        "jib_emitter_deserialized_groups", (
            _emitter getVariable [
                "jib_emitter_deserialized_groups", []
            ]
        ) + _deserializedGroups
    ];
};

jib_emitter__addDeserializedUnits = {
    params ["_emitter", "_deserializedUnits"];
    _emitter setVariable [
        "jib_emitter_deserialized_units", (
            _emitter getVariable [
                "jib_emitter_deserialized_units", []
            ]
        ) + _deserializedUnits
    ];
};

jib_emitter__addDeserializedCrate = {
    params ["_emitter", "_deserializedCrate"];
    _emitter setVariable [
        "jib_emitter_deserialized_crates", (
            _emitter getVariable [
                "jib_emitter_deserialized_crates", []
            ]
        ) + [_deserializedCrate]
    ];
};

jib_emitter__addtocurators = {
    params ["_object"];
    if (jib_emitter_debug) then {
        allCurators apply {
            _x addCuratorEditableObjects [[_object], false];
        };
    };
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

jib_emitter__deserialize_batch = {
    params ["_serializedBatch"];
    _serializedBatch params [
        "_serializedVehicles",
        "_serializedGroups",
        "_serializedSeats"
    ];
    private _vehicles = _serializedVehicles apply {
        [_x] call jib_emitter__deserialize_vehicle;
    };
    private _groups = _serializedGroups apply {
        [_x] call jib_emitter__deserialize_group;
    };
    [
        _vehicles, _groups, _serializedSeats
    ] call jib_emitter__deserialize_seats;

    uiSleep jib_emitter_delay_physics;
    _vehicles apply {_x allowDamage true};
    _groups apply {units _x apply {_x allowDamage true}};

    private _paths = [
        _emitter, count _groups - 1
    ] call jib_emitter__waypoint_search;
    if (count _paths != count _groups) then {
        throw format [
            "Num paths expected: %1, actual: %2",
            count _groups, count _paths
        ];
    };
    for "_i" from 0 to count _groups - 1 do {
        private _group = _groups # _i;
        private _path = _paths # _i;
        [_group, _path] call jib_emitter__waypoint_path;
    };

    [_emitter, _batch] call jib_emitter__addDeserializedBatch;
    [_emitter, _vehicles] call jib_emitter__addDeserializedVehicles;
    [_emitter, _groups] call jib_emitter__addDeserializedGroups;
    [
        _emitter, flatten (_groups apply {units _x})
    ] call jib_emitter__addDeserializedUnits;

    [_vehicles, _groups];
};

jib_emitter__deserialize_crate = {
    uiSleep jib_emitter_delay_physics;
    params ["_serializedCrate"];
    _serializedCrate params [
        "_type", "_posATL", "_direction", "_serializedInventory"
    ];

    private _crate =
        createVehicle [_type, _posATL, [], 0, "NONE"];
    _crate allowDamage false;
    [_crate] call jib_emitter__addtocurators;
    _crate setDir _direction;
    [
        _crate, _serializedInventory
    ] call jib_emitter__deserialize_inventory;

    uiSleep jib_emitter_delay_physics;
    _crate allowDamage true;
    [_emitter, _crate] call jib_emitter__addDeserializedCrate;
    _crate;
};

jib_emitter__deserialize_group = {
    params ["_serializedGroup"];
    _serializedGroup params [
        "_name",
        "_deleteWhenEmpty",
        "_side",
        "_formation",
        "_combatMode",
        "_speedMode",
        "_serializedUnits",
        "_serializedWaypoints"
    ];
    private _group = createGroup [_side, _deleteWhenEmpty];
    // _group setGroupIdGlobal [format "%1 %2", _name, random 1];
    _group setFormation _formation;
    _group setCombatMode _combatMode;
    _group setSpeedMode _speedMode;
    _serializedUnits apply {
        [_group, _x] call jib_emitter__deserialize_soldier;
    };
    _serializedWaypoints apply {
        [_group, _x] call jib_emitter__deserialize_waypoint;
    };
    _group;
};

jib_emitter__deserialize_inventory = {
    params ["_container", "_serializedInventory"];
    _serializedInventory params [
        "_items", "_weapons", "_magazines", "_backpacks"
    ];

    clearItemCargoGlobal _container;
    clearWeaponCargoGlobal _container;
    clearMagazineCargoGlobal _container;
    clearBackpackCargoGlobal _container;

    _items apply {_container addItemCargoGlobal [_x, 1]};
    _weapons apply {
        _container addWeaponWithAttachmentsCargoGlobal [_x, 1]
    };
    _magazines apply {
        _x params ["_type", "_ammo"];
        _container addMagazineAmmoCargo [_type, 1, _ammo];
    };
    _backpacks apply {
        _x params ["_type", "_cargo"];
        _container addBackpackCargoGlobal [_type, 1];
        // No way to add cargo
    };
};

jib_emitter__deserialize_seats = {
    uiSleep jib_emitter_delay_physics;
    params ["_vehicles", "_groups", "_serializedSeats"];
    _serializedSeats apply {
        _x params [
            "_vehicleIndex", "_groupIndex", "_unitIndex",
            "_role", "_cargoIndex", "_turretPath", "_personTurret"
        ];
        private _vehicle = _vehicles # _vehicleIndex;
        private _soldier = units (_groups # _groupIndex) # _unitIndex;
        switch (_role) do
        {
            case "driver": {_soldier moveInDriver _vehicle};
            case "gunner": {_soldier moveInGunner _vehicle};
            case "commander": {_soldier moveInCommander _vehicle};
            case "turret": {
                _soldier moveInTurret [_vehicle, _turretPath];
            };
            case "cargo": {
                _soldier moveInCargo [_vehicle, _cargoIndex, true];
            };
            default {};
        };
    };
};

jib_emitter__deserialize_soldier = {
    uiSleep jib_emitter_delay_physics;
    params ["_group", "_serializedSoldier"];
    _serializedSoldier params [
        "_type",
        "_posATL",
        "_direction",
        "_rank",
        "_skill",
        "_combatBehaviour",
        "_combatMode",
        "_loadout"
    ];
    private _soldier =
        _group createUnit [_type, _posATL, [], 0, "NONE"];
    _soldier allowDamage false;
    [_soldier] call jib_emitter__addtocurators;
    _soldier setDir _direction;
    _soldier setRank _rank;
    _soldier setSkill _skill;
    _soldier setCombatBehaviour _combatBehaviour;
    _soldier setUnitCombatMode _combatMode;
    _soldier setUnitLoadout _loadout; // TODO: Maybe refresh backpack
    _soldier;
};

jib_emitter__deserialize_vehicle = {
    uiSleep jib_emitter_delay_physics;
    params ["_serializedVehicle"];
    _serializedVehicle params [
        "_type", "_posATL", "_direction", "_special",
        "_serializedInventory"
    ];
    private _vehicle =
        createVehicle [_type, _posATL, [], 0, _special];
    _vehicle allowDamage false;
    [_vehicle] call jib_emitter__addtocurators;
    _vehicle setDir _direction;
    [
        _vehicle, _serializedInventory
    ] call jib_emitter__deserialize_inventory;
    _vehicle;
};

jib_emitter__deserialize_waypoint = {
    params ["_group", "_serializedWaypoint"];
    _serializedWaypoint params [
        "_posATL",
        "_radius",
        "_type",
        "_formation",
        "_behaviour",
        "_combatMode",
        "_speed",
        "_timeout",
        "_statements"
    ];
    private _index = count waypoints _group;
    _group addWaypoint [_posATL, _radius];
    [_group, _index] setWaypointType _type;
    [_group, _index] setWaypointFormation _formation;
    [_group, _index] setWaypointBehaviour _behaviour;
    [_group, _index] setWaypointCombatMode _combatMode;
    [_group, _index] setWaypointSpeed _speed;
    [_group, _index] setWaypointTimeout _timeout;
    [_group, _index] setWaypointStatements _statements;
    [_group, _index];
};

jib_emitter__getDeserializedBatches = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_batches", []
    ] select {
        _x params ["_vehicles", "_groups"];
        {alive _x} count _vehicles > 0
            || {{alive _x} count units _x > 0} count _groups > 0;
    };
};

jib_emitter__getDeserializedVehicles = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_vehicles", []
    ] select {alive _x};
};

jib_emitter__getDeserializedGroups = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_groups", []
    ] select {{alive _x} count units _x > 0};
};

jib_emitter__getDeserializedUnits = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_units", []
    ] select {alive _x};
};

jib_emitter__getDeserializedCrates = {
    params ["_emitter"];
    _emitter getVariable [
        "jib_emitter_deserialized_crates", []
    ] select {alive _x};
};

jib_emitter__selectfromlist = {
    params ["_list", ["_index", -1, [0]]];
    if (_index < 0) then {selectRandom _list} else {_list # _index};
};

jib_emitter__serialize_batch = {
    params ["_vehicles", "_groups"];
    private _serializedVehicles =
        _vehicles apply {[_x] call jib_emitter__serialize_vehicle};
    private _serializedGroups =
        _groups apply {[_x] call jib_emitter__serialize_group};
    private _serializedSeats =
        [_vehicles, _groups] call jib_emitter__serialize_seats;
    [_serializedVehicles, _serializedGroups, _serializedSeats];
};

jib_emitter__serialize_crate = {
    params ["_crate"];
    [
        typeOf _crate,
        getPosATL _crate,
        direction _crate,
        [_crate] call jib_emitter__serialize_inventory
    ];
};

jib_emitter__serialize_group = {
    params ["_group"];
    [
        groupId _group,
        true, // isGroupDeletedWhenEmpty
        side _group,
        formation _group,
        combatMode _group,
        speedMode _group,
        units _group apply {
            [_x] call jib_emitter__serialize_soldier;
        },
        waypoints _group select [
            1, count waypoints _group - 1
        ] apply {
            _x call jib_emitter__serialize_waypoint;
        }
    ];
};

jib_emitter__serialize_inventory = {
    params ["_container"];
    [
        itemCargo _container,
        weaponsItemsCargo _container,
        magazinesAmmoCargo _container,
        everyBackpack _container apply {
            getBackpackCargo _x params ["_types", "_quantities"];
            private _cargo = [];
            for "_i" from 0 to count _types - 1 do {
                _cargo pushBack [_types # _i, _quantities # _i];
            };
            [typeOf _x, _cargo];
        }
    ]
};

jib_emitter__serialize_seats = {
    params ["_vehicles", "_groups"];
    private _serializedSeats = [];
    for "_vehicleIndex" from 0 to count _vehicles - 1 do {
        fullCrew [_vehicles # _vehicleIndex, ""] apply {
            _x params [
                "_unit", "_role", "_cargoIndex",
                "_turretPath", "_personTurret"
            ];
            for "_groupIndex" from 0 to count _groups - 1 do {
                for "_unitIndex" from 0 to (
                    count units (_groups # _groupIndex) - 1
                ) do {
                    if (
                        units (_groups # _groupIndex) # _unitIndex
                            == _unit
                    ) then {
                        _serializedSeats pushBack [
                            _vehicleIndex, _groupIndex, _unitIndex,
                            _role, _cargoIndex,
                            _turretPath, _personTurret
                        ];
                    };
                };
            };
        };
    };
    _serializedSeats;
};

jib_emitter__serialize_soldier = {
    params ["_soldier"];
    [
        typeOf _soldier,
        getPosATL _soldier,
        direction _soldier,
        rank _soldier,
        skill _soldier,
        combatBehaviour _soldier,
        combatMode _soldier,
        getUnitLoadout _soldier
    ];
};

jib_emitter__serialize_vehicle = {
    params ["_vehicle"];
    [
        typeOf _vehicle,
        getPosATL _vehicle,
        direction _vehicle,
        if (isTouchingGround _vehicle) then {"NONE"} else {"FLY"},
        [_vehicle] call jib_emitter__serialize_inventory
    ];
};

jib_emitter__serialize_waypoint = {
    [
        waypointPosition _this,
        waypointCompletionRadius _this, // placement radius hack
        waypointType _this,
        waypointFormation _this,
        waypointBehaviour _this,
        waypointCombatMode _this,
        waypointSpeed _this,
        waypointTimeout _this,
        waypointStatements _this
    ];
};

jib_emitter__waypoint_path = {
    params ["_group", "_path"];
    _path apply {
        [
            _group, _x getVariable [
                "jib_emitter_serialized_waypoint", []
            ]
        ] call jib_emitter__deserialize_waypoint;
    };
};

jib_emitter__waypoint_search = {
    params [
        "_root",
        ["_numChildPaths", 0, [0]],
        ["_blacklist", [], [[]]]
    ];
    private _path = [_root];
    private _childPaths = [];
    private _getRelatives = {
        params ["_node", "_path", "_blacklist"];
        private _getNeighbors = {
            params ["_node", "_path", "_blacklist", "_type"];
            private _synchronizedNodes = [];
            synchronizedObjects _node select {
                _x getVariable ["jib_emitter_type", ""] == _type
                    && _x getVariable ["jib_emitter_enabled", false]
                    && !(_x in _path) && !(_x in _blacklist)
            } apply {
                _synchronizedNodes pushBack _x;
                _synchronizedNodes pushBack (
                    _x getVariable ["jib_emitter_weight", 1]
                );
            };
        };
        private _relatives =
            [_node, _path, _blacklist, "waypoint"] call _getNeighbors;
        private _children =
            [_node, _path, _blacklist, "child"] call _getNeighbors;
        if (count _children > 0 && _numChildPaths > 0) then {
            for "_i" from 0 to _numChildPaths - 1 do {
                private _child = selectRandomWeighted _children;
                _childPaths pushBack (
                    (
                        [
                            _child, 0, _path
                        ] call jib_emitter__waypoint_search
                    ) # 0
                );
            };
            _numChildPaths = 0;
        };
        _relatives;
    };

    private _relatives = [_root, _path] call _getRelatives;
    while {count _relatives != 0} do {
        private _neighbor = selectRandomWeighted _relatives;
        _path pushBack _neighbor;
        _relatives = [_root, _path] call _getRelatives;
    };
    [_path] + _childPaths;
};
