jib_emitter_delay_physics = 0.3;
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
    ];

    _logic setVariable ["jib_emitter_type", "waypoint"];
    _logic setVariable ["jib_emitter_weight", _weight];
    _logic setVariable ["jib_emitter_enabled", _enabled];
    _logic setVariable [
        "jib_emitter_serialized_waypoint", _serializedWaypoint
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

    _logic setVariable ["jib_emitter_type", "child"];
    _logic setVariable ["jib_emitter_weight", _weight];
    _logic setVariable ["jib_emitter_enabled", _enabled];
    _logic;
};

// Enable waypoint
jib_emitter_waypoint_enable = {
    params ["_waypoint"];
    _waypoint setVariable ["jib_emitter_enabled", true];
};

// Disable waypoint
jib_emitter_waypoint_disable = {
    params ["_waypoint"];
    _waypoint setVariable ["jib_emitter_enabled", false];
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
        "jib_emitter_handle",
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

            while {true} do {
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
                        [jib_emitter__getDeserializedBatches,
                         _concurrentBatches],
                        [jib_emitter__getDeserializedVehicles,
                         _concurrentVehicles],
                        [jib_emitter__getDeserializedGroups,
                         _concurrentGroups],
                        [jib_emitter__getDeserializedUnits,
                         _concurrentUnits]
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
        0, 0, 0, 0,          // budget B, V, G, U
        1, 0, [0, 0, 0],     // coef mem, coef rand, rand
        1, 1.1, 0, 0, 0, 120 // coef exp, exp, coef pow, pow, min, max
    ] call jib_emitter_enable;
};

// Emitter preset for motorized
jib_emitter_enable_motorized = {
    params ["_emitter"];
    [
        _emitter, [1, 1, 1],
        0, 2, 0, 8,
        0, 0, 0, 0,
        1, 0, [10, 10, 10],
        1, 1.1, 0, 0, 0, 120
    ] call jib_emitter_enable;
};

// Emitter preset for air
jib_emitter_enable_air = {
    params ["_emitter"];
    [
        _emitter, [1, 1, 1],
        0, 1, 0, 12,
        0, 0, 0, 0,
        1, 0, [10, 10, 10],
        1, 1.1, 0, 0, 0, 300
    ] call jib_emitter_enable;
};

// Stop emitting continuously
jib_emitter_disable = {
    params ["_emitter"];
    terminate (_emitter getVariable ["jib_emitter_handle", scriptNull]);
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
    _batch params ["_vehicles", "_groups"];
    private _units = flatten (_groups apply {units _x});

    [[_batch], _vehicles, _groups, _units];
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
    private _batch = [_vehicles, _groups];

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

    _batch;
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
    ] select {alive _x && {alive _x} count crew _x > 0};
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
    private _path = [];
    private _childPaths = [];

    private _relatives = [
        _root, _path + _blacklist, _childPaths, _numChildPaths
    ] call jib_emitter__waypoint_getRelatives;
    while {count _relatives != 0} do {
        private _neighbor = selectRandomWeighted _relatives;
        _path pushBack _neighbor;
        _relatives = [
            _neighbor, _path + _blacklist, _childPaths, _numChildPaths
        ] call jib_emitter__waypoint_getRelatives;
    };
    [_path] + _childPaths;
};

jib_emitter__waypoint_getRelatives = {
    params ["_node", "_blacklist", "_childPaths", "_numChildPaths"];
    private _relatives = [
        _node, _blacklist, "waypoint"
    ] call jib_emitter__waypoint_getNeighbors;
    private _children = [
        _node, _blacklist, "child"
    ] call jib_emitter__waypoint_getNeighbors;
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

jib_emitter__waypoint_getNeighbors = {
    params ["_node", "_blacklist", "_type"];
    private _synchronizedNodes = [];
    synchronizedObjects _node select {
        _x getVariable ["jib_emitter_type", ""] == _type
            && _x getVariable ["jib_emitter_enabled", false]
            && !(_x in _blacklist)
    } apply {
        _synchronizedNodes pushBack _x;
        _synchronizedNodes pushBack (
            _x getVariable ["jib_emitter_weight", 1]
        );
    };
    _synchronizedNodes;
};
