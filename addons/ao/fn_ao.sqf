// Dependencies
jib_ao_acre_setUnitLoadout = jib_acre_setUnitLoadout;
jib_ao_ai_cqb = jib_ai_cqb;

// Config
jib_ao_debug = true;
jib_ao_sleep_delay = 0.1;

// Default param values.

// Public

// Private

// Get unit, vehicle, seat data for group
jib_ao__group_read = {
    params ["_group"];
    private _data = [
        [
            groupId _group,
            true, // isGroupDeletedWhenEmpty
            side _group,
            formation _group,
            combatMode _group,
            speedMode _group,
            _group getVariable ["lambs_danger_disableGroupAI", false]
        ],
        units _group apply {
            [
                typeOf _x,
                getPos _x,
                direction _x,
                rank _x,
                skill _x,
                combatBehaviour _x,
                combatMode _x,
                getUnitLoadout _x,
                canTriggerDynamicSimulation _x,
                isDamageAllowed _x,
                leader _x == _x,
                _x getVariable ["jib_ao_allowFleeing", 0], // HACK
                _x getVariable ["lambs_danger_disableAI", false],
                [
                    _x skill "aimingAccuracy",
                    _x skill "aimingShake",
                    _x skill "aimingSpeed",
                    _x skill "endurance",
                    _x skill "spotDistance",
                    _x skill "spotTime",
                    _x skill "courage",
                    _x skill "reloadSpeed",
                    _x skill "commanding",
                    _x skill "general"
                ]
            ]
        },
        assignedVehicles _group apply {
            private _vehicle = _x;
            [
                typeOf _x,
                getPos _x,
                direction _x,
                isDamageAllowed _x,
                if (isTouchingGround _x) then {"NONE"} else {"FLY"},
                [
                    itemCargo _x,
                    weaponsItemsCargo _x,
                    magazinesAmmoCargo _x,
                    everyBackpack _x apply {
                        getBackpackCargo _x params ["_types", "_quantities"];
                        private _cargo = [];
                        for "_i" from 0 to count _types - 1 do {
                            _cargo pushBack [_types # _i, _quantities # _i];
                        };
                        [typeOf _x, _cargo];
                    }
                ]
            ]
        },
        [units _group, assignedVehicles _group] call {
            params ["_units", "_vehicles"];
            private _seats = [];
            for "_vehicleIndex" from 0 to count _vehicles - 1 do {
                fullCrew [_vehicles # _vehicleIndex, ""] apply {
                    _x params [
                        "_unit", "_role", "_cargoIndex",
                        "_turretPath", "_personTurret"
                    ];
                    for "_unitIndex" from 0 to count _units - 1 do {
                        if (_units # _unitIndex == _unit) then {
                            _seats pushBack [
                                _vehicleIndex, _unitIndex, _role, _cargoIndex,
                                _turretPath, _personTurret
                            ];
                        }
                    };
                }
            };
            _seats;
        }
    ];
    assignedVehicles _group apply {
        deleteVehicleCrew _x;
        deleteVehicle _x;
    };
    units _group apply {
        deleteVehicle _x;
    };
    deleteGroup _group;
    _data;
};

// Spawn group, units, vehicles at given positions
jib_ao__group_write = {
    // Unpack data
    params ["_data", "_data_pos_dir"];
    _data params [
        "_data_group", "_data_units", "_data_vehicles", "_data_seats"
    ];
    _data_pos_dir params [
        "_positions_unit", "_positions_vehicle",
        "_directions_unit", "_directions_vehicle"
    ];

    // Create group
    _data_group params [
        "_name",
        "_deleteWhenEmpty",
        "_side",
        "_formation",
        "_combatMode",
        "_speedMode",
        "_lambs_danger_disableGroupAI"
    ];
    private _group = createGroup [_side, _deleteWhenEmpty];
    // _group setGroupIdGlobal [format "%1 %2", _name, random 1];
    _group setFormation _formation;
    _group setCombatMode _combatMode;
    _group setSpeedMode _speedMode;
    _group setVariable [
        "lambs_danger_disableGroupAI", _lambs_danger_disableGroupAI
    ];
    if (jib_ao_sleep_delay >= 0) then {
        uiSleep jib_ao_sleep_delay;
    };

    // Spawn vehicles
    private _vehicles = [];
    for "_i" from 0 to count _data_vehicles - 1 do {
        // Setup
        private _data_vehicle = _data_vehicles # _i;
        private _pos = (
            if (count _positions_vehicle > _i) then {
                _positions_vehicle # _i
            } else {
                _positions_vehicle # 0
            }
        );
        private _dir = (
            if (count _directions_vehicle > _i) then {
                _directions_vehicle # _i
            } else {
                _directions_vehicle # 0
            }
        );
        // Vehicle
        _data_vehicle params [
            "_type", "_posSerial", "_dirSerial",
            "_isDamageAllowed", "_special", "_inventory"
        ];
        private _vehicle = createVehicle [_type, _pos, [], 0, _special];
        _vehicle allowDamage false;
        [_vehicle, false] remoteExec ["enableSimulationGlobal", 2];
        _vehicle setVariable ["jib_ao__damage", _isDamageAllowed];
        [_vehicle] call jib_ao__curator_register;
        _vehicle setDir _dir;
        // Inventory
        _inventory params [
            "_items", "_weapons", "_magazines", "_backpacks"
        ];
        clearItemCargoGlobal _vehicle;
        clearWeaponCargoGlobal _vehicle;
        clearMagazineCargoGlobal _vehicle;
        clearBackpackCargoGlobal _vehicle;
        _items apply {_vehicle addItemCargoGlobal [_x, 1]};
        _weapons apply {
            _vehicle addWeaponWithAttachmentsCargoGlobal [_x, 1]
        };
        _magazines apply {
            _x params ["_type", "_ammo"];
            _vehicle addMagazineAmmoCargo [_type, 1, _ammo];
        };
        _backpacks apply {
            _x params ["_type", "_cargo"];
            _vehicle addBackpackCargoGlobal [_type, 1];
            // No way to add cargo
        };
        // Hack to fix planes
        if (_vehicle isKindOf "Plane") then {
            [_vehicle] spawn {
                params ["_vehicle"];
                waitUntil {
                    if (jib_ao_sleep_delay >= 0) then {
                        uiSleep jib_ao_sleep_delay;
                    };
                    !alive _vehicle || alive driver _vehicle;
                };
                [_vehicle, 10, 0] call BIS_fnc_setPitchBank;
                _vehicle setVelocityModelSpace [0, 200, 0];
            }
        };
        // Cleanup
        _vehicles pushBack _vehicle;
        if (jib_ao_sleep_delay >= 0) then {
            uiSleep jib_ao_sleep_delay;
        };
    };

    // Spawn units
    private _units = [];
    for "_i" from 0 to count _data_units - 1 do {
        // Setup
        private _data_unit = _data_units # _i;
        private _pos = (
            if (count _positions_unit > _i) then {
                _positions_unit # _i
            } else {
                _positions_unit # 0
            }
        );
        private _dir = (
            if (count _directions_unit > _i) then {
                _directions_unit # _i
            } else {
                _directions_unit # 0
            }
        );
        // Unit
        _data_unit params [
            "_type",
            "_posSerial",
            "_dirSerial",
            "_rank",
            "_skill",
            "_combatBehaviour",
            "_combatMode",
            "_loadout",
            "_canTriggerDynamicSimulation",
            "_isDamageAllowed",
            "_leader",
            "_fleeing",
            "_lambs_danger_disableAI",
            "_skillDetail"
        ];
        private _unit = _group createUnit [
            _type, [_pos # 0, _pos # 1, 0], [], 0, "NONE"
        ];
        [_unit] joinSilent _group;
        _unit allowDamage false;
        [_unit, false] remoteExec ["enableSimulationGlobal", 2];
        _unit setVariable ["jib_ao__damage", _isDamageAllowed];
        _unit setVariable ["jib_ao__leader", _leader];
        [_unit] call jib_ao__curator_register;
        _unit setDir _dir;
        _unit setRank _rank;
        _unit setSkill _skill;
        _unit setCombatBehaviour _combatBehaviour;
        _unit setUnitCombatMode _combatMode;
        [_unit, _loadout] call jib_ao_acre_setUnitLoadout;
        _unit triggerDynamicSimulation _canTriggerDynamicSimulation;
        if (_fleeing != -1) then {
            _unit allowFleeing _fleeing;
            _unit setVariable ["jib_ao__fleeing", _fleeing]; // debug
        };
        _unit setVariable ["lambs_danger_disableAI", _lambs_danger_disableAI];
        // Skill
        _skillDetail params [
            "_skill_aimingAccuracy",
            "_skill_aimingShake",
            "_skill_aimingSpeed",
            "_skill_endurance",
            "_skill_spotDistance",
            "_skill_spotTime",
            "_skill_courage",
            "_skill_reloadSpeed",
            "_skill_commanding",
            "_skill_general"
        ];
        _unit setSkill ["aimingAccuracy", _skill_aimingAccuracy];
        _unit setSkill ["aimingShake", _skill_aimingShake];
        _unit setSkill ["aimingSpeed", _skill_aimingSpeed];
        _unit setSkill ["endurance", _skill_endurance];
        _unit setSkill ["spotDistance", _skill_spotDistance];
        _unit setSkill ["spotTime", _skill_spotTime];
        _unit setSkill ["courage", _skill_courage];
        _unit setSkill ["reloadSpeed", _skill_reloadSpeed];
        _unit setSkill ["commanding", _skill_commanding];
        _unit setSkill ["general", _skill_general];
        // Cleanup
        _units pushBack _unit;
        if (jib_ao_sleep_delay >= 0) then {
            uiSleep jib_ao_sleep_delay;
        };
    };
    _units apply {
        if (_x getVariable ["jib_ao__leader", false]) then {
            _group selectLeader _x;
        };
    };

    // Move units into vehicle seats
    _data_seats apply {
        _x params [
            "_vehicleIndex", "_unitIndex",
            "_role", "_cargoIndex", "_turretPath", "_personTurret"
        ];
        // TODO: Try addVehicle, see if fixes some guys dismounting
        private _vehicle = _vehicles # _vehicleIndex;
        private _unit = _units # _unitIndex;
        switch (_role) do
        {
            case "driver": {_unit moveInDriver _vehicle};
            case "gunner": {_unit moveInGunner _vehicle};
            case "commander": {_unit moveInCommander _vehicle};
            case "turret": {
                _unit moveInTurret [_vehicle, _turretPath];
            };
            case "cargo": {
                _unit moveInCargo [_vehicle, _cargoIndex, true];
            };
            default {};
        };
    };
    if (jib_ao_sleep_delay >= 0) then {
        uiSleep jib_ao_sleep_delay;
    };

    // Cleanup
    _units apply {
        _x allowDamage (_x getVariable ["jib_ao__damage", true]);
    };
    _vehicles apply {
        _x allowDamage (_x getVariable ["jib_ao__damage", true]);
    };
    [[_units, _vehicles], {
        params ["_units", "_vehicles"];
        _units apply {_x enableSimulationGlobal true;};
        _vehicles apply {_x enableSimulationGlobal true;};
    }] remoteExec ["spawn", 2];
    [_group, _units, _vehicles];
};

// Iteratively merge clusters smaller than threshold into closest cluster.
jib_ao__cluster_merge = {
    // Setup
    params [
        "_clusters",
        "_threshold",
        ["_progress_delay", 3, [1]]
    ];
    private _start_time = uiTime;
    private _progress_time = uiTime;
    private _queue = _clusters apply {
        [_x, [_x] call jib_ao__cluster_mean, false]
    }; // mark clean
    private _kdtree = [];
    [format ["jib_ao__cluster_merge building data tree..."]] call jib_ao__log;
    for "_i" from 0 to count _queue - 1 do {
        private _entry = _queue # _i;
        _entry params ["_cluster", "_centroid", "_dirty"];
        if (uiTime > _progress_time + _progress_delay) then {
            _progress_time = uiTime;
            [
                format [
                    "jib_ao__cluster_merge building data tree... (%1 / %2)",
                    _i, count _queue
                ]
            ] call jib_ao__log;
        };
        _kdtree = [_kdtree, _centroid, _entry] call jib_ao__kdtree_insert;
    };
    private _index = 0;
    // Process queue
    while {_index < count _queue} do {
        private _entry = _queue # _index;
        if (uiTime > _progress_time + _progress_delay) then {
            _progress_time = uiTime;
            [
                format [
                    "jib_ao__cluster_merge merging clusters... (%1 / %2)",
                    _index, count _queue
                ]
            ] call jib_ao__log;
        };
        // Check if dirty
        _entry params ["_cluster", "_centroid", "_dirty"];
        if (_dirty) then {
            // ["Cluster dirty, continue"] call jib_ao__log;
            _index = _index + 1;
            continue;
        };
        if (count _cluster >= _threshold) then {
            // ["Cluster good, continue"] call jib_ao__log;
            _index = _index + 1;
            continue;
        };
        _entry set [2, true]; // mark dirty
        // Get other to merge with
        private _other = [_kdtree, _centroid, {
            params ["_node_data"];
            _node_data params ["_cluster", "_centroid", "_dirty"];
            !_dirty; // ensure other is not this or dirty
        }] call jib_ao__kdtree_nearest;
        if (count _other == 0) then {
            _entry set [2, false]; // merge failed
            // ["Cluster merge failed, continue"] call jib_ao__log;
            _index = _index + 1;
            continue;
        };
        _other params [
            "_other_pos", "_other_data", "_other_left", "_other_right"
        ];
        _other_data params [
            "_other_cluster", "_other_centroid", "_other_dirty"
        ];
        _other_data set [2, true]; // mark other dirty
        // Create new cluster
        private _new_cluster = _cluster + _other_cluster;
        private _new_centroid = [_new_cluster] call jib_ao__cluster_mean;
        private _new_entry =
            [_new_cluster, _new_centroid, false]; // mark clean
        _queue pushBack _new_entry;
        [_kdtree, _new_centroid, _new_entry] call jib_ao__kdtree_insert;
        // ["Cluster merge done, continue"] call jib_ao__log;
        _index = _index + 1;
    };
    private _result = _queue select {
        _x params ["_cluster", "_centroid", "_dirty"];
        !_dirty;
    } apply {
        _x params ["_cluster", "_centroid", "_dirty"];
        _cluster;
    };
    [format [
        "jib_ao__cluster_merge done (%1 processed, %2 returned, %3 seconds)",
        count _queue, count _result, uiTime - _start_time
    ]] call jib_ao__log;
    _result;
};

// Partition clusters larger than threshold to be approximately that size.
jib_ao__cluster_partition = {
    // Setup
    params [
        "_clusters",
        "_threshold"
    ];
    private _result = [];
    _clusters apply {
        if (count _x <= _threshold) then {
            _result pushBack _x;
        } else {
            private _partitions =
                [_x, ceil (count _x / _threshold)] call jib_ao__cluster_kmeans;
            _partitions apply {
                _result pushBack _x;
            };
        };
    };
    _result;
};

// Calculate mean of a cluster.
jib_ao__cluster_mean = {
    params ["_cluster"];
    private _mean = [0, 0, 0];
    _cluster apply {
        _mean = _mean vectorAdd _x;
    };
    if (count _cluster > 0) then {
        _mean = _mean vectorMultiply (1 / count _cluster);
    } else {
        _mean = [];
    };
    _mean;
};

// Cluster and return points into given number of clusters.
//
// Balance option ensures each cluster has same number of points, but tends to
// be unstable.
jib_ao__cluster_kmeans = {
    // Setup
    params [
        "_positions",
        "_k",
        ["_max_iterations", 100, [0]],
        ["_min_delta", 0.1, [0]],
        ["_balance", false, [true]]
    ];
    private _slots = count _positions;
    _sizes = _sizes select {
        _slots = _slots - _x;
        _slots >= 0;
    };
    private _size = ceil (count _positions / _k);
    _positions = _positions apply {[random 1, _x]};
    _positions sort false;
    _positions = _positions apply {_x # 1};
    private _centroids = _positions select [0, _k];
    private _iteration = 0;
    private _clusters = [];
    while {true} do {
        // Iteration setup
        _iteration = _iteration + 1;
        if (_iteration > _max_iterations) then {
            ["Max iterations reached."] call jib_ao__log;
            break;
        };
        _clusters = [];
        for "_i" from 0 to count _centroids - 1 do {
            _clusters pushBack [];
        };
        // Assign points to clusters
        _positions apply {
            private _best_cluster = -1;
            private _best_distance = 1e9;
            private _position = _x;
            for "_i" from 0 to count _centroids - 1 do {
                private _centroid = _centroids # _i;
                if (
                    _position distance _centroid < _best_distance
                        && (!_balance || count (_clusters # _i) < _size)
                ) then {
                    _best_cluster = _i;
                    _best_distance = _position distance _centroid;
                };
            };
            if (_best_cluster >= 0) then {
                _clusters # _best_cluster pushBack _position;
            };
        };
        // Check for convergence
        private _n_stable = 0;
        for "_i" from 0 to count _centroids - 1 do {
            private _sum = [0, 0, 0];
            private _n = 0;
            _clusters # _i apply {
                _sum = _sum vectorAdd _x;
                _n = _n + 1;
            };
            private _new_centroid = selectRandom _positions;
            if (_n > 0) then {
                _new_centroid = _sum vectorMultiply (1 / _n);
            };
            private _old_centroid = _centroids # _i;
            if (_new_centroid distance _old_centroid <= _min_delta) then {
                _n_stable = _n_stable + 1;
            };
            _centroids set [_i, _new_centroid];
        };
        if (_n_stable >= count _clusters) then {
            [
                format ["Centroids stabile, %1 iterations.", _iteration]
            ] call jib_ao__log;
            break;
        };
    };
    _clusters;
};

// Draw clusters for debug purposes
jib_ao__cluster_draw = {
    params [
        "_clusters",
        ["_draw_distance", 1000, [1]]
    ];
    if (!isNil "jib_ao__cluster_draw_handle") then {
        removeMissionEventHandler ["Draw3D", jib_ao__cluster_draw_handle];
    };
    jib_ao__cluster_draw_handle = addMissionEventHandler ["Draw3D", {
        _thisArgs params ["_Clusters", "_draw_distance"];
        for "_i" from 0 to count _clusters - 1 do {
            // Calculate centroid
            private _positions = _clusters # _i;
            private _centroid = [0, 0, 0];
            private _n = 0;
            _positions apply {
                _centroid = _centroid vectorAdd _x;
                _n = _n + 1;
            };
            if (_n > 0) then {
                _centroid = _centroid vectorMultiply (1 / _n);
            } else {
                [format ["Empty cluster %1", _i]] call jib_ao__log;
            };
            if (
                isNull curatorCamera ||
                    {curatorCamera distance _centroid > _draw_distance}
            ) then {
                continue;
            };
            // Draw title
            private _icon = "\A3\ui_f\data\map\markers\military\dot_CA.paa";
            private _color = [0,1,0,.5];
            private _offset = 10;
            private _shadow = false;
            private _iconSize = 1;
            private _textSize = 1;
            private _textFont = "RobotoCondensedBold";
            private _textAlign = "right";
            drawIcon3D [
                _icon,
                _color,
                _centroid vectorAdd [0, 0, _offset],
                _iconSize,
                _iconSize,
                0,
                format ["Cluster %1 (size %2)", _i, count _positions],
                _shadow
                // _textSize,
                // _textFont,
                // _textAlign
            ];
            // Draw positions
            for "_j" from 0 to count _positions - 1 do {
                private _position = _positions # _j;
                drawIcon3D [
                    _icon,
                    _color,
                    _position,
                    _iconSize,
                    _iconSize,
                    0,
                    "",
                    _shadow
                    // _textSize,
                    // _textFont,
                    // _textAlign
                ];
                drawLine3D [
                    _centroid vectorAdd [0, 0, _offset],
                    _position,
                    _color
                ];
            };
        };
    }, [_clusters, _draw_distance]];
};

// Insert position into 3D tree.
jib_ao__kdtree_insert = {
    params [
        "_node",
        "_pos",
        "_data",
        ["_depth", 0]
    ];
    if (count _node == 0) exitWith {
        // [format ["jib_ao__kdtree_insert depth: %1", _depth]] call jib_ao__log;
        [_pos, _data, [], []];
    };
    _node params ["_node_pos", "_node_data", "_node_left", "_node_right"];
    private _axis = _depth % 3;
    if (_pos # _axis < _node_pos # _axis) then {
        _node set [
            2,
            [_node # 2, _pos, _data, _depth + 1] call jib_ao__kdtree_insert
        ]; // left
    } else {
        _node set [
           3,
            [_node # 3, _pos, _data, _depth + 1] call jib_ao__kdtree_insert
        ]; // right
    };
    _node;
};

// Retrieve nearest node in 3D tree.
jib_ao__kdtree_nearest = {
    params [
        "_node",
        "_pos",
        ["_predicate", {true}, [{}]],
        ["_best_node", [[]]],
        ["_best_dist", [1e9]],
        ["_depth", 0]
    ];
    if (count _node == 0) exitWith {[];};
    _node params ["_node_pos", "_node_data", "_node_left", "_node_right"];
    private _distance = _node_pos distance _pos;
    if (
        [_node_data] call _predicate
            && _distance < _best_dist # 0
    ) then {
        _best_dist set [0, _distance];
        _best_node set [0, _node];
    };
    private _axis = _depth % 3;
    private _left = _pos # _axis < _node_pos # _axis;
    private _next = if (_left) then {_node_left} else {_node_right};
    private _other = if (_left) then {_node_right} else {_node_left};
    [
        _next, _pos, _predicate, _best_node, _best_dist, _depth + 1
    ] call jib_ao__kdtree_nearest;
    if (abs(_pos # _axis - _node_pos # _axis) < _best_dist # 0) then {
        [
            _other, _pos, _predicate, _best_node, _best_dist, _depth + 1
        ] call jib_ao__kdtree_nearest;
    };
    _best_node # 0;
};

// Add object to curator
jib_ao__curator_register = {
    params ["_object"];
    if (jib_ao_debug) then {
        // NOTE: Called frequently, may cause network bottleneck
        [[_object], {
            params ["_object"];
            allCurators apply {
                _x addCuratorEditableObjects [[_object], false];
            };
        }] remoteExec ["spawn", 2];
    };
};

// Log a message
jib_ao__log = {
    params ["_message"];
    diag_log format ["jib_ao: %1", _message];
    if (jib_ao_debug) then {
        systemChat format ["jib_ao: %1", _message];
    };
};

// Unit test kdtree functions
jib_ao__test_kdtree = {
    // Test insert and retrieve
    private _points = [
        [[0, 0, 0], "origin"],
        [[1, 0, 0], "right"],
        [[-1, 0, 0], "left"],
        [[0, .5, 0], "forward near"]
    ];
    private _tree = [];
    _points apply {
        _x params ["_pos", "_label"];
        _tree = [_tree, _pos, _label] call jib_ao__kdtree_insert;
    };
    private _expected = "forward near";
    private _actual = ([_tree, [0, .4, 0]] call jib_ao__kdtree_nearest) # 1;
    if (_expected != _actual) then {
        throw format [
            "jib_ao__kdtree_nearest: %1 not equal to %2", _expected, _actual
        ];
    };

    // Test insert and retrieve with predicate
    private _points = [
        [[0, 0, 0], "origin"],
        [[1, 0, 0], "right"],
        [[-1, 0, 0], "left"],
        [[0, .5, 0], "forward near"]
    ];
    private _tree = [];
    _points apply {
        _x params ["_pos", "_label"];
        _tree = [_tree, _pos, _label] call jib_ao__kdtree_insert;
    };
    private _expected = "right";
    private _actual = ([
        _tree, [0, .4, 0], {
            params ["_data"];
            _data == "right";
        }
    ] call jib_ao__kdtree_nearest) # 1;
    if (_expected != _actual) then {
        throw format [
            "jib_ao__kdtree_nearest: %1 not equal to %2", _expected, _actual
        ];
    };
};

// Unit test cluster functions
jib_ao__test_cluster = {
    // Test merge threshold 1
    ["jib_ao__cluster_merge test threshold 1"] call jib_ao__log;
    private _clusters = [
        [[0, 0, 0]],
        [[1, 1, 1]]
    ];
    private _merged = [_clusters, 1] call jib_ao__cluster_merge;
    if (count _merged != 2) then {
        throw format ["jib_ao__cluster_merge: bad count %1", count _merged];
    };

    // Test merge threshold 2
    ["jib_ao__cluster_merge test threshold 2"] call jib_ao__log;
    private _clusters = [
        [[0, 0, 0]],
        [[1, 1, 1]]
    ];
    private _merged = [_clusters, 2] call jib_ao__cluster_merge;
    if (count _merged != 1) then {
        throw format ["jib_ao__cluster_merge: bad count %1", count _merged];
    };
};

// Run unit tests
if (jib_ao_debug) then {
    call jib_ao__test_kdtree;
    call jib_ao__test_cluster;
};
