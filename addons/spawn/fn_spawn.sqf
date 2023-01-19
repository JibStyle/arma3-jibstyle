jib_spawn_delay = 0.3;
jib_spawn_debug = false;
jib_spawn_count = 0;

jib_spawn_register_emitter = {
    params [
        "_logic",
        ["_weight", 1, [0]]
    ];
    _logic setVariable ["jib_spawn_type", "emitter"];
    _logic setVariable ["jib_spawn_weight", _weight];
    _logic setVariable [
        "jib_spawn_batches",
        synchronizedObjects _logic apply {
            switch (_x call BIS_fnc_objectType select 0) do
            {
                case "Soldier";
                case "Vehicle";
                case "VehicleAutonomous": {
                    private _vehicles =
                        units group effectiveCommander _x apply {
                            assignedVehicle _x;
                        } select { not isNull _x };
                    _vehicles = _vehicles arrayIntersect _vehicles;
                    for "_i" from 0 to count _vehicles - 1 do {
                        fullCrew [_vehicles # _i, ""] apply {
                            _x params [
                                "_unit",
                                "_role",
                                "_cargoIndex",
                                "_turretPath",
                                "_personTurret"
                            ];
                            _unit setVariable [
                                "jib_spawn_unit_vehicle_role",
                                [
                                    _i,
                                    _role,
                                    _cargoIndex,
                                    _turretPath,
                                    _personTurret
                                ]
                            ];
                        };
                    };

                    private _groups = flatten [
                        group effectiveCommander _x,
                        _vehicles apply {crew _x apply {group _x}}
                    ];
                    _groups = _groups arrayIntersect _groups;

                    [
                        _vehicles apply {
                            [typeOf _x, getPosATL _x, direction _x]
                        },
                        _groups apply {
                            [
                                groupId _x,
                                true, // isGroupDeletedWhenEmpty
                                side _x,
                                formation _x,
                                combatMode _x,
                                speedMode _x,
                                units _x apply {
                                    [
                                        typeOf _x,
                                        getPosATL _x,
                                        direction _x,
                                        rank _x,
                                        skill _x,
                                        combatBehaviour _x,
                                        combatMode _x,
                                        _x getVariable [
                                            "jib_spawn_unit_vehicle_role",
                                            []
                                        ]
                                    ];
                                }
                            ];
                        }
                    ];
                };

                default {[]};
            };
        } select {count _x > 0}
    ];
    [_logic] spawn {
        params ["_logic"];
        synchronizedObjects _logic apply {
            switch (_x call BIS_fnc_objectType select 0) do
            {
                case "Soldier";
                case "Vehicle";
                case "VehicleAutonomous": {
                    private _vehicles =
                        units group effectiveCommander _x apply {
                            assignedVehicle _x;
                        } select { not isNull _x };
                    _vehicles = _vehicles arrayIntersect _vehicles;
                    private _groups = flatten [
                        group effectiveCommander _x,
                        _vehicles apply {crew _x apply {group _x}}
                    ];
                    _groups = _groups arrayIntersect _groups;
                    private _deleteVehicles = [];
                    _groups apply {
                        units _x apply {
                            _deleteVehicles pushBackUnique vehicle _x;
                        };
                    };
                    _deleteVehicles apply {
                        deleteVehicleCrew _x;
                        deleteVehicle _x;
                    };
                    _groups apply { deleteGroup _x };
                };
                default {[]};
            };
        };
    };
};

jib_spawn_register_waypoint = {
    params [
        "_logic",
        ["_weight", 1, [0]],
        ["_radius", 0, [0]],
        ["_type", "MOVE", [""]],
        ["_formation", "NO CHANGE", [""]],
        ["_behaviour", "UNCHANGED", [""]],
        ["_mode", "NO CHANGE", [""]],
        ["_speed", "UNCHANGED", [""]],
        ["_timeout", [0, 0, 0], [[]]],
        ["_statements", ["true", ""], [[]]]
    ];
    _logic setVariable ["jib_spawn_wp_weight", _weight];
    _logic setVariable ["jib_spawn_wp_radius", _radius];
    _logic setVariable ["jib_spawn_wp_egress", false];
    _logic setVariable ["jib_spawn_wp_type", _type];
    _logic setVariable ["jib_spawn_wp_formation", _formation];
    _logic setVariable ["jib_spawn_wp_behaviour", _behaviour];
    _logic setVariable ["jib_spawn_wp_mode", _mode];
    _logic setVariable ["jib_spawn_wp_speed", _speed];
    _logic setVariable ["jib_spawn_wp_timeout", _timeout];
    _logic setVariable ["jib_spawn_wp_statements", _statements];
    _logic setVariable ["jib_spawn_type", "waypoint"];
};

jib_spawn_register_egress = {
    params [
        "_logic",
        ["_weight", 1, [0]],
        ["_radius", 0, [0]],
        ["_type", "MOVE", [""]],
        ["_formation", "NO CHANGE", [""]],
        ["_behaviour", "UNCHANGED", [""]],
        ["_mode", "NO CHANGE", [""]],
        ["_speed", "UNCHANGED", [""]],
        ["_timeout", [0, 0, 0], [[]]],
        ["_statements", ["true", ""], [[]]]
    ];
    _logic setVariable ["jib_spawn_wp_weight", _weight];
    _logic setVariable ["jib_spawn_wp_radius", _radius];
    _logic setVariable ["jib_spawn_wp_egress", true];
    _logic setVariable ["jib_spawn_wp_type", _type];
    _logic setVariable ["jib_spawn_wp_formation", _formation];
    _logic setVariable ["jib_spawn_wp_behaviour", _behaviour];
    _logic setVariable ["jib_spawn_wp_mode", _mode];
    _logic setVariable ["jib_spawn_wp_speed", _speed];
    _logic setVariable ["jib_spawn_wp_timeout", _timeout];
    _logic setVariable ["jib_spawn_wp_statements", _statements];
    _logic setVariable ["jib_spawn_type", "waypoint"];
};

jib_spawn_activate_trigger = {
    params [
        "_trigger",
        ["_randomNum", [1, 1, 1], [[]]]
    ];
    if (!canSuspend) then {throw "Cannot suspend!"};
    private _n = round random _randomNum;
    private _choices = [];
    synchronizedObjects _trigger select {
        _x getVariable ["jib_spawn_type", ""] == "emitter"
    } apply {
        _choices pushBack _x;
        _choices pushBack (_x getVariable ["jib_spawn_weight", 1]);
    };

    for "_i" from 0 to (_n - 1) do {
        [
            selectRandomWeighted _choices
        ] call jib_spawn_activate_emitter;
        sleep jib_spawn_delay;
    };
};

jib_spawn_deactivate_trigger = {
    params ["_trigger"];
    if (!isServer) exitWith {};
    synchronizedObjects _trigger select {
        _x getVariable ["jib_spawn_type", ""] == "emitter";
    } apply {
        private _emitter = _x;
        synchronizedObjects _emitter select {
            _x isKindOf "EmptyDetector"
        } apply {_x synchronizeObjectsRemove [_emitter]};
    };
};

jib_spawn_activate_emitter = {
    params ["_logic"];
    if (!canSuspend) then {throw "Cannot suspend!"};
    selectRandom (
        _logic getVariable ["jib_spawn_batches", []]
    ) params ["_vehicles", "_groups"];
    [_logic] call jib_spawn_choose_waypoints params [
        "_waypoints", "_tr_waypoints"
    ];

    private _add_to_curators = {
        params ["_object"];
        if (jib_spawn_debug) then {
            allCurators apply {
                _x addCuratorEditableObjects [[_object], false];
            };
        };
    };
    private _spawn_vehicle = {
        sleep jib_spawn_delay;
        params ["_vehicle"];
        _vehicle params ["_type", "_posATL", "_direction"];
        _vehicle = createVehicle [_type, _posATL, [], 0, "FLY"];
        _vehicle allowDamage false;
        [_vehicle] call _add_to_curators;
        _vehicle setDir _direction; // maybe delay
        _vehicle;
    };
    private _spawn_group = {
        sleep jib_spawn_delay;
        params ["_group", "_vehicles"];
        _group params [
            "_name",
            "_deleteWhenEmpty",
            "_side",
            "_formation",
            "_combatMode",
            "_speedMode",
            "_units"
        ];
        _group = createGroup [_side, _deleteWhenEmpty];
        jib_spawn_count = jib_spawn_count + 1;
        // TODO: Fix race condition
        // _group setGroupIdGlobal [
        //     format ["%1 %2", _name, jib_spawn_count]
        // ];
        _units apply {
            _x params [
                "_type",
                "_posATL",
                "_direction",
                "_rank",
                "_skill",
                "_combatBehaviour",
                "_combatMode",
                "_vehicleRole"
            ];
            private _unit =
                _group createUnit [_type, _posATL, [], 0, "NONE"];
            _unit allowDamage false;
            [_unit] call _add_to_curators;
            _unit setDir _direction; // maybe delay
            _unit setRank _rank;
            _unit setSkill _skill;
            _unit setCombatBehaviour _combatBehaviour;
            _unit setUnitCombatMode _combatMode;
            if (count _vehicleRole > 0) then {
                // sleep jib_spawn_delay;
                _vehicleRole params [
                    "_vehicleIndex",
                    "_role",
                    "_cargoIndex",
                    "_turretPath",
                    "_personTurret"
                ];
                private _vehicle = _vehicles # _vehicleIndex;
                switch (_role) do
                {
                    case "driver": {
                        _unit moveInDriver _vehicle;
                    };
                    case "gunner": {
                        _unit moveInGunner _vehicle;
                    };
                    case "commander": {
                        _unit moveInCommander _vehicle;
                    };
                    case "turret": {
                        _unit moveInTurret [_vehicle, _turretPath];
                    };
                    case "cargo": {
                        _unit moveInCargo [
                            _vehicle, _cargoIndex, true
                        ];
                    };
                    default {};
                };
            };
            _unit;
        };
        _group;
    };
    private _add_waypoints = {
        params ["_group", "_waypoints"];
        _waypoints apply {
            _x params [
                ["_type", "MOVE", [""]],
                ["_posATL", [0, 0, 0], [[]]],
                ["_radius", 0, [0]],
                ["_formation", "NO CHANGE", [""]],
                ["_behaviour", "UNCHANGED", [""]],
                ["_mode", "NO CHANGE", [""]],
                ["_speed", "UNCHANGED", [""]],
                ["_timeout", [0, 0, 0], [[]]],
                ["_statements", ["true", ""], [[]]]
            ];
            private _index = count waypoints _group;
            _group addWaypoint [_posATL, _radius];
            [_group, _index] setWaypointType _type;
            [_group, _index] setWaypointFormation _formation;
            [_group, _index] setWaypointBehaviour _behaviour;
            [_group, _index] setWaypointCombatMode _mode;
            [_group, _index] setWaypointSpeed _speed;
            [_group, _index] setWaypointTimeout _timeout;
            [_group, _index] setWaypointStatements _statements;
        };
    };

    _vehicles = _vehicles apply {[_x] call _spawn_vehicle};
    _groups = _groups apply {[_x, _vehicles] call _spawn_group};
    if (count _groups == 1) then {
        [_groups # 0, _waypoints] call _add_waypoints;
    } else {
        [_groups # 0, _tr_waypoints] call _add_waypoints;
        for "_i" from 1 to count _groups - 1 do {
            [_groups # _i, _waypoints] call _add_waypoints;
        };
    };

    sleep jib_spawn_delay;
    _vehicles apply {_x allowDamage true};
    _groups apply {units _x apply {_x allowDamage true}};
    [_vehicles, _groups];
};

jib_spawn_choose_waypoints = {
    params ["_logic"];
    private _visited = [_logic];
    private _transport = [];
    private _get_fringe = {
        params ["_logic", "_visited", "_egress"];
        private _fringe = [];
        synchronizedObjects _logic select {
            _x call BIS_fnc_objectType params ["_category", "_type"];
            _category == "Logic"
                && _type == "Logic"
                && !(_x in _visited)
                && _x getVariable ["jib_spawn_type", ""] == "waypoint"
                && (
                    _x getVariable ["jib_spawn_wp_egress", false]
                        == _egress
                );
        } apply {
            _fringe pushBack _x;
            _fringe pushBack (
                _x getVariable ["jib_spawn_wp_weight", 1]
            );
        };
        _fringe;
    };

    private _fringe = [_logic, _visited, false] call _get_fringe;
    while {count _fringe != 0} do {
        private _next = selectRandomWeighted _fringe;
        _visited pushBack _next;
        _fringe = [_next, _visited, false] call _get_fringe;
        if (
            _next getVariable ["jib_spawn_wp_type", ""] == "TR UNLOAD"
        ) then {
            _transport = _visited;
            _visited = [_next];
        };
    };
    _visited deleteAt 0;

    if (count _transport > 0) then {
        _fringe = [
            _transport # (count _transport - 1), _transport, true
        ] call _get_fringe;
        while {count _fringe != 0} do {
            private _next = selectRandomWeighted _fringe;
            _transport pushBack _next;
            _fringe = [_next, _transport, false] call _get_fringe;
        };
        _transport deleteAt 0;
    };

    private _transform = {[
        _x getVariable ["jib_spawn_wp_type", "MOVE"],
        getPosATL _x,
        _x getVariable ["jib_spawn_wp_radius", 0],
        _x getVariable ["jib_spawn_wp_formation", "NO CHANGE"],
        _x getVariable ["jib_spawn_wp_behaviour", "UNCHANGED"],
        _x getVariable ["jib_spawn_wp_mode", "NO CHANGE"],
        _x getVariable ["jib_spawn_wp_speed", "UNCHANGED"],
        _x getVariable ["jib_spawn_wp_timeout", [0, 0, 0]],
        _x getVariable ["jib_spawn_wp_statements", ["true", ""]]
    ]};
    _visited = _visited apply _transform;
    _transport = _transport apply _transform;
    [_visited, _transport];
};
