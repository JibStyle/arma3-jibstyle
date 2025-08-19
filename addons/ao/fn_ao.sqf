// Dependencies
jib_ao_acre_setUnitLoadout = jib_acre_setUnitLoadout;
jib_ao_ai_cqb = jib_ai_cqb;

// Config
jib_ao_debug = true;
jib_ao_sleep_delay = 0.1;
jib_ao_progress_delay = 3;
jib_ao_cluster_supercluster_threshold = 100;
jib_ao_cluster_draw_offset = 10;

// Default param values.
jib_ao_default_unit_init = {
    params ["_unit"];
};
jib_ao_default_group_init = {
    params ["_group"];
    [
        _group, 1, 2, 3, random [0, 0.7, 1], random [0, 10, 200], 2
    ] call jib_ao_ai_cqb;
};

// Public

// Private

// Get unit data
jib_ao__serial_read_group = {
    params ["_group"];
    if (isNull _group) exitWith {
        ["jib_ao__serial_read_group: Null group."] call jib_ao__log;
        [];
    };
    private _group_data = [
        groupId _group,
        true, // isGroupDeletedWhenEmpty
        side _group,
        formation _group,
        combatMode _group,
        speedMode _group,
        _group getVariable ["lambs_danger_disableGroupAI", false]
    ];
    _group deleteGroupWhenEmpty true;
    _group_data;
};

// Get unit data
jib_ao__serial_read_unit = {
    params ["_unit"];
    if (not alive _unit) exitWith {
        // ["jib_ao__serial_read_unit: Null or dead unit."] call jib_ao__log;
        [];
    };
    private _unit_data = [
        typeOf _unit,
        getPos _unit,
        direction _unit,
        rank _unit,
        skill _unit,
        combatBehaviour _unit,
        combatMode _unit,
        getUnitLoadout _unit,
        canTriggerDynamicSimulation _unit,
        isDamageAllowed _unit,
        leader _unit == _unit,
        _unit getVariable ["jib_ao_allowFleeing", 0], // HACK
        _unit getVariable ["lambs_danger_disableAI", false],
        [
            _unit skill "aimingAccuracy",
            _unit skill "aimingShake",
            _unit skill "aimingSpeed",
            _unit skill "endurance",
            _unit skill "spotDistance",
            _unit skill "spotTime",
            _unit skill "courage",
            _unit skill "reloadSpeed",
            _unit skill "commanding",
            _unit skill "general"
        ]
    ];
    private _vehicle = vehicle _unit;
    deleteVehicle _unit;
    if (count crew _vehicle == 0) then {deleteVehicle _vehicle;};
    _unit_data;
};

// Spawn group
jib_ao__serial_write_group = {
    params ["_group_data"];
    _group_data params [
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
    _group;
};

// Spawn unit with group and position
jib_ao__serial_write_unit = {
    params ["_unit_data", "_group", "_pos", "_dir"];
    _unit_data params [
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
    private _unit = _group createUnit [_type, _pos, [], 0, "CAN_COLLIDE"];
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
    if (jib_ao_sleep_delay >= 0) then {
        uiSleep jib_ao_sleep_delay;
    };
    _unit allowDamage (_unit getVariable ["jib_ao__damage", true]);
    [_unit, true] remoteExec ["enableSimulationGlobal", 2];
    _unit;
};

// Populate clusters with unit data.
jib_ao__population_generate = {
    params [
        "_clusters",
        "_groups_units_data",
        ["_p_cluster", 1, [0]],
        ["_p_point", 1, [0]]
    ];
    _clusters apply {
        if (random 1 >= _p_cluster) then {
            ["jib_ao__cluster_populate: Skip cluster."] call jib_ao__log;
            continue;
        };
        private _cluster = _x;
        _cluster params [
            "_cluster_points", "_cluster_centroid",
            "_cluster_group_data", "_cluster_group"
        ];
        private _group_units_data = selectRandom _groups_units_data;
        _group_units_data params ["_group_data", "_units_data"];
        [_cluster, _group_data] call jib_ao__cluster_set_group_data;
        _cluster_points apply {
            if (random 1 >= _p_point) then {
                ["jib_ao__cluster_populate: Skip point."] call jib_ao__log;
                continue;
            };
            private _cluster_point = _x;
            _cluster_point params ["_pos", "_unit_data", "_unit"];
            private _unit_data = selectRandom _units_data;
            [
                _cluster_point, _unit_data
            ] call jib_ao__cluster_point_set_unit_data;
        };
    };
    _clusters;
};

// Spawn in a cluster.
jib_ao__population_add = {
    params [
        "_cluster",
        ["_unit_init", jib_ao_default_unit_init, [{}]],
        ["_group_init", jib_ao_default_group_init, [{}]]
    ];
    _cluster params [
        "_cluster_points", "_cluster_centroid",
        "_cluster_group_data", "_cluster_group"
    ];
    if (count _cluster_group_data == 0) exitWith {
        ["jib_ao__population_add: Null group detected."] call jib_ao__log;
    };
    private _group = [_cluster_group_data] call jib_ao__serial_write_group;
    [_cluster, _group] call jib_ao__cluster_set_group;
    _cluster_points apply {
        private _cluster_point = _x;
        _cluster_point params ["_pos", "_unit_data", "_unit"];
        if (count _unit_data == 0) then {
            continue;
        };
        private _unit = [
            _unit_data, _group, _pos, random 360
        ] call jib_ao__serial_write_unit;
        [_cluster_point, _unit] call jib_ao__cluster_point_set_unit;
        [_unit] call _unit_init;
    };
    [_group] call _group_init;
    _group;
};

// Despawn a cluster.
jib_ao__population_remove = {
    params ["_cluster"];
    _cluster params [
        "_cluster_points", "_cluster_centroid",
        "_cluster_group_data", "_cluster_group"
    ];
    if (isNull _cluster_group) exitWith {
        // Maybe group is all dead.
        ["jib_ao__population_remove: Null group detected."] call jib_ao__log;
        [_cluster, []] call jib_ao__cluster_set_group_data;
        _cluster_points apply {
            private _cluster_point = _x;
            [_cluster_point, []] call jib_ao__cluster_point_set_unit_data;
        };
    };
    // private _group_data = [_cluster_group] call jib_ao__serial_read_group;
    // [_cluster, _group_data] call jib_ao__cluster_set_group_data;
    _cluster_points apply {
        private _cluster_point = _x;
        _cluster_point params ["_pos", "_unit_data", "_unit"];
        private _unit_data = [_unit] call jib_ao__serial_read_unit;
        [_cluster_point, _unit_data] call jib_ao__cluster_point_set_unit_data;
    };
};

// Get lists of clusters to add and remove
jib_ao__population_resolve = {
    params [
        "_clusters",
        ["_epsilon", 0.1, [0]]
    ];
    private _clusters_expected = [_clusters] call jib_ao__cluster_near;
    private _clusters_actual = _clusters select {
        private _cluster = _x;
        _cluster params [
            "_cluster_points", "_cluster_centroid",
            "_cluster_group_data", "_cluster_group"
        ];
        not isNull _cluster_group;
    };
    private _clusters_add = [];
    private _clusters_remove = [];
    _clusters_expected apply {
        private _cluster_expected = _x;
        _cluster_expected params [
            "_cluster_expected_points", "_cluster_expected_centroid",
            "_cluster_expected_group_data", "_cluster_expected_group"
        ];
        private _found = false;
        _clusters_actual apply {
            private _cluster_actual = _x;
            _cluster_actual params [
                "_cluster_actual_points", "_cluster_actual_centroid",
                "_cluster_actual_group_data", "_cluster_actual_group"
            ];
            if (
                _cluster_expected_centroid distance _cluster_actual_centroid
                    < _epsilon
            ) exitWith {
                // Poor man's equality check
                _found = true;
            };
        };
        if (!_found) then {
            _clusters_add pushBack _cluster_expected;
        };
    };
    _clusters_actual apply {
        private _cluster_actual = _x;
        _cluster_actual params [
            "_cluster_actual_points", "_cluster_actual_centroid",
            "_cluster_actual_group_data", "_cluster_actual_group"
        ];
        private _found = false;
        _clusters_expected apply {
            private _cluster_expected = _x;
            _cluster_expected params [
                "_cluster_expected_points", "_cluster_expected_centroid",
                "_cluster_expected_group_data", "_cluster_expected_group"
            ];
            if (
                _cluster_actual_centroid distance _cluster_expected_centroid
                    < _epsilon
            ) exitWith {
                // Poor man's equality check
                _found = true;
            };
        };
        if (!_found) then {
            _clusters_remove pushBack _cluster_actual;
        };
    };
    [_clusters_add, _clusters_remove];
};

// Process buildings to generate clusters.
jib_ao__cluster_supercluster = {
    params [
        "_buildings",
        ["_threshold_merge", 4, [0]],
        ["_threshold_partition", 8, [0]]
    ];
    private _start_time = uiTime;
    private _clusters = [];
    private _debug_superclusters = []; // pos offset for drawing
    private _initial_supercluster_points = _buildings apply {
        private _building = _x;
        private _cluster_points = _building buildingPos -1 apply {
            private _pos = _x;
            private _cluster_point =
                [_pos, [], objNull] call jib_ao__cluster_point_make;
            _cluster_point;
        };
        private _cluster_centroid =
            [_cluster_points] call jib_ao__cluster_mean;
        private _cluster = [
            _cluster_points, _cluster_centroid, [], grpNull
        ] call jib_ao__cluster_make;
        private _supercluster_point = [getPos _building, _cluster];
        _supercluster_point;
    };
    private _initial_supercluster_centroid =
        [_initial_supercluster_points] call jib_ao__cluster_mean;
    private _superclusters = [
        [
            _initial_supercluster_points,
            _initial_supercluster_centroid,
            [],
            grpNull
        ] call jib_ao__cluster_make
    ];
    _superclusters = [
        _superclusters, jib_ao_cluster_supercluster_threshold, true
    ] call jib_ao__cluster_partition;
    for "_i" from 0 to count _superclusters - 1 do {
        [
            format [
                "jib_ao__cluster_supercluster: %1 / %2 (%3 sec)...",
                _i + 1, count _superclusters, uiTime - _start_time
            ]
        ] call jib_ao__log;
        private _cluster = _superclusters # _i;
        _cluster params [
            "_cluster_points", "_cluster_centroid",
            "_cluster_group_data", "_cluster_group"
        ];
        private _supercluster_clusters = _cluster_points apply {
            private _cluster_point = _x;
            _cluster_point params ["_pos", "_unit_data", "_unit"];
            private _cluster = _unit_data; // hack
            _cluster;
        };
        _supercluster_clusters = [
            _supercluster_clusters, _threshold_merge
        ] call jib_ao__cluster_merge;
        _supercluster_clusters = [
            _supercluster_clusters, _threshold_partition, false
        ] call jib_ao__cluster_partition;
        _supercluster_clusters apply {_clusters pushBack _x};
        private _debug_supercluster_points = _supercluster_clusters apply {
            private _cluster = _x;
            _cluster params [
                "_cluster_points", "_cluster_centroid",
                "_cluster_group_data", "_cluster_group"
            ];
            private _pos = (
                [_cluster_points] call jib_ao__cluster_mean
            ) vectorAdd [0, 0, jib_ao_cluster_draw_offset];
            private _cluster_point =
                [_pos, [], objNull] call jib_ao__cluster_point_make;
            _cluster_point;
        };
        private _debug_supercluster_centroid =
            [_debug_supercluster_points] call jib_ao__cluster_mean;
        private _debug_supercluster = [
            _debug_supercluster_points,
            _debug_supercluster_centroid,
            ["hack"], // hack
            grpNull
        ] call jib_ao__cluster_make;
        _debug_superclusters pushBack _debug_supercluster;
    };
    [
        format [
            "jib_ao__cluster_supercluster: Done (%1 sec).",
            uiTime - _start_time
        ]
    ] call jib_ao__log;
    [_clusters, _debug_superclusters];
};

// Make a cluster object.
jib_ao__cluster_make = {
    params [
        "_cluster_points", "_cluster_centroid",
        "_cluster_group_data", "_cluster_group"
    ];
    private _cluster = [
        _cluster_points, _cluster_centroid,
        _cluster_group_data, _cluster_group
    ];
    _cluster;
};

// Update cluster group data.
jib_ao__cluster_set_group_data = {
    params ["_cluster", "_group_data"];
    _cluster set [2, _group_data];
};

// Update cluster group.
jib_ao__cluster_set_group = {
    params ["_cluster", "_group"];
    _cluster set [3, _group];
};

// Make a cluster point.
jib_ao__cluster_point_make = {
    params ["_pos", "_unit_data", "_unit"];
    private _cluster_point = [_pos, _unit_data, _unit];
    _cluster_point;
};

// Update cluster point unit data.
jib_ao__cluster_point_set_unit_data = {
    params ["_cluster_point", "_unit_data"];
    _cluster_point set [1, _unit_data];
};

// Update cluster point unit.
jib_ao__cluster_point_set_unit = {
    params ["_cluster_point", "_unit"];
    _cluster_point set [2, _unit];
};

// Get near clusters.
jib_ao__cluster_near = {
    params [
        "_clusters",
        ["_n_clusters", -1, [0]],
        ["_n_points", 100, [0]],
        ["_distance", -1, [0]]
    ];
    private _clusters_near = [];
    private _n_points_actual = 0;
    private _clusters_sorted = _clusters apply {
        private _cluster = _x;
        _cluster params [
            "_cluster_points", "_cluster_centroid",
            "_cluster_group_data", "_cluster_group"
        ];
        private _best = 1e9;
        if (count _cluster_group_data == 0) then {
            continueWith [_best, _cluster];
        };
        allPlayers + allCurators apply {
            private _target = _x;
            private _distance = _target distance _cluster_centroid;
            if (_distance < _best) then {
                _best = _distance;
            };
            if (!isNull _cluster_group) then {
                _cluster_points apply {
                    private _cluster_point = _x;
                    _cluster_point params ["_pos", "_unit_data", "_unit"];
                    if (alive _unit) then {
                        private _distance = _target distance _unit;
                        if (_distance < _best) then {
                            _best = _distance;
                        };
                    };
                };
            };
        };
        [_best, _cluster];
    };
    _clusters_sorted sort true;
    _clusters_sorted apply {
        _x params ["_score", "_cluster"];
        _cluster params [
            "_cluster_points", "_cluster_centroid",
            "_cluster_group_data", "_cluster_group"
        ];
        if (_n_points >= 0 && _n_points_actual >= _n_points) then {
            break;
        };
        if (_n_clusters >= 0 && count _clusters_near >= _n_clusters) then {
            break;
        };
        if (_distance >= 0 && _score > _distance) then {
            break;
        };
        _clusters_near pushBack _cluster;
        _n_points_actual = _n_points_actual + count _cluster_points;
    };
    _clusters_near;
};

// Iteratively merge clusters smaller than threshold into closest cluster.
jib_ao__cluster_merge = {
    // Setup
    params [
        "_clusters",
        "_threshold"
    ];
    private _start_time = uiTime;
    private _progress_time = uiTime;
    private _queue = _clusters apply {
        private _cluster = _x;
        _cluster params [
            "_cluster_points", "_cluster_centroid",
            "_cluster_group_data", "_cluster_group"
        ];
        [_cluster, false];
    }; // mark clean
    private _kdtree = [];
    [format ["jib_ao__cluster_merge building data tree..."]] call jib_ao__log;
    for "_i" from 0 to count _queue - 1 do {
        private _entry = _queue # _i;
        _entry params ["_cluster", "_dirty"];
        _cluster params [
            "_cluster_points", "_cluster_centroid",
            "_cluster_group_data", "_cluster_group"
        ];
        if (uiTime > _progress_time + jib_ao_progress_delay) then {
            _progress_time = uiTime;
            [
                format [
                    "jib_ao__cluster_merge building data tree... (%1 / %2)",
                    _i, count _queue
                ]
            ] call jib_ao__log;
        };
        _kdtree =
            [_kdtree, _cluster_centroid, _entry] call jib_ao__kdtree_insert;
    };
    private _index = 0;
    // Process queue
    while {_index < count _queue} do {
        private _entry = _queue # _index;
        if (uiTime > _progress_time + jib_ao_progress_delay) then {
            _progress_time = uiTime;
            [
                format [
                    "jib_ao__cluster_merge merging clusters... (%1 / %2)",
                    _index, count _queue
                ]
            ] call jib_ao__log;
        };
        // Check if dirty
        _entry params ["_cluster", "_dirty"];
        _cluster params [
            "_cluster_points", "_cluster_centroid",
            "_cluster_group_data", "_cluster_group"
        ];
        if (_dirty) then {
            // ["Cluster dirty, continue"] call jib_ao__log;
            _index = _index + 1;
            continue;
        };
        if (count _cluster_points >= _threshold) then {
            // ["Cluster good, continue"] call jib_ao__log;
            _index = _index + 1;
            continue;
        };
        _entry set [1, true]; // mark dirty
        // Get other to merge with
        private _other = [_kdtree, _cluster_centroid, {
            params ["_node_data"];
            _node_data params ["_cluster", "_dirty"];
            _cluster params [
                "_cluster_points", "_cluster_centroid",
                "_cluster_group_data", "_cluster_group"
            ];
            !_dirty; // ensure other is not this or dirty
        }] call jib_ao__kdtree_nearest;
        if (count _other == 0) then {
            _entry set [1, false]; // merge failed
            // ["Cluster merge failed, continue"] call jib_ao__log;
            _index = _index + 1;
            continue;
        };
        _other params [
            "_other_pos", "_other_data", "_other_left", "_other_right"
        ];
        _other_data params [
            "_other_cluster", "_other_dirty"
        ];
        _other_cluster params [
            "_other_cluster_points", "_other_cluster_centroid",
            "_other_cluster_enabled", "_other_cluster_active"
        ];
        _other_data set [1, true]; // mark other dirty
        // Create new cluster
        private _new_cluster_points = _cluster_points + _other_cluster_points;
        private _new_cluster_centroid =
            [_new_cluster_points] call jib_ao__cluster_mean;
        private _new_cluster = [
            _new_cluster_points, _new_cluster_centroid, [], grpNull
        ] call jib_ao__cluster_make;
        private _new_entry = [_new_cluster, false]; // mark clean
        _queue pushBack _new_entry;
        [
            _kdtree, _new_cluster_centroid, _new_entry
        ] call jib_ao__kdtree_insert;
        // ["Cluster merge done, continue"] call jib_ao__log;
        _index = _index + 1;
    };
    private _result = _queue select {
        _x params ["_cluster", "_dirty"];
        !_dirty;
    } apply {
        _x params ["_cluster", "_dirty"];
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
    params ["_clusters", "_threshold", ["_logging", false]];
    private _result = [];
    _clusters apply {
        private _cluster = _x;
        _cluster params [
            "_cluster_points", "_cluster_centroid",
            "_cluster_group_data", "_cluster_group"
        ];
        if (count _cluster_points <= _threshold) then {
            _result pushBack _cluster;
        } else {
            private _partitions = [
                _cluster_points,
                ceil (count _cluster_points / _threshold),
                _logging
            ] call jib_ao__cluster_kmeans;
            _partitions apply {
                private _cluster_points = _x;
                private _cluster_centroid =
                    [_cluster_points] call jib_ao__cluster_mean;
                _result pushBack (
                    [
                        _cluster_points, _cluster_centroid, [], grpNull
                    ] call jib_ao__cluster_make
                );
            };
        };
    };
    _result;
};

// Calculate mean of a list of cluster points.
jib_ao__cluster_mean = {
    params ["_cluster_points"];
    private _mean = [0, 0, 0];
    _cluster_points apply {
        private _cluster_point = _x;
        _cluster_point params ["_pos", "_unit_data", "_unit"];
        _mean = _mean vectorAdd _pos;
    };
    if (count _cluster_points > 0) then {
        _mean = _mean vectorMultiply (1 / count _cluster_points);
    } else {
        _mean = [];
    };
    _mean;
};

// Cluster and return points into given number of partitions.
//
// Balance option ensures each cluster has same number of points, but tends to
// be unstable.
jib_ao__cluster_kmeans = {
    // Setup
    params [
        "_points",
        "_k",
        ["_logging", false, [true]],
        ["_timeout", 60, [0]],
        ["_max_iterations", 100, [0]],
        ["_epsilon", 0.1, [0]],
        ["_balance", false, [true]]
    ];
    private _start_time = uiTime;
    private _size = ceil (count _points / _k);
    _points = _points apply {[random 1, _x]};
    _points sort false;
    _points = _points apply {_x # 1};
    private _centroids = _points select [0, _k] apply {
        private _cluster_point = _x;
        _cluster_point params ["_pos", "_unit_data", "_unit"];
        _pos;
    };
    private _iteration = 0;
    private _partitions = [];
    while {true} do {
        // Iteration setup
        if (_logging) then {
            [
                format [
                    "jib_ao__cluster_kmeans: Iteration %1 (%2 sec)...",
                    _iteration + 1, uiTime - _start_time
                ]
            ] call jib_ao__log;
        };
        _partitions = [];
        for "_i" from 0 to count _centroids - 1 do {
            _partitions pushBack [];
        };
        // Assign points to partitions
        _points apply {
            private _cluster_point = _x;
            _cluster_point params ["_pos", "_unit_data", "_unit"];
            private _best_partition = -1;
            private _best_distance = 1e9;
            for "_i" from 0 to count _centroids - 1 do {
                private _centroid = _centroids # _i;
                if (
                    _pos distance _centroid < _best_distance
                        && (!_balance || count (_partitions # _i) < _size)
                ) then {
                    _best_partition = _i;
                    _best_distance = _pos distance _centroid;
                };
            };
            if (_best_partition >= 0) then {
                _partitions # _best_partition pushBack _x;
            };
        };
        // Check for convergence
        private _n_stable = 0;
        for "_i" from 0 to count _centroids - 1 do {
            private _sum = [0, 0, 0];
            private _n = 0;
            _partitions # _i apply {
                private _cluster_point = _x;
                _cluster_point params ["_pos", "_unit_data", "_unit"];
                _sum = _sum vectorAdd _pos;
                _n = _n + 1;
            };
            private _new_centroid = selectRandom _points # 0;
            if (_n > 0) then {
                _new_centroid = _sum vectorMultiply (1 / _n);
            };
            private _old_centroid = _centroids # _i;
            if (_new_centroid distance _old_centroid <= _epsilon) then {
                _n_stable = _n_stable + 1;
            };
            _centroids set [_i, _new_centroid];
        };
        // Loop handling
        if (_logging) then {
            [
                format [
                    "jib_ao__cluster_kmeans: %1 / %2 partitions stable.",
                    _n_stable, _k
                ]
            ] call jib_ao__log;
        };
        if (_n_stable >= count _partitions) then {
            if (_logging) then {
                [
                    format [
                        "jib_ao__cluster_kmeans: "
                            + "Done (%1 iterations, %2 sec).",
                        _iteration + 1, uiTime - _start_time
                    ]
                ] call jib_ao__log;
            };
            break;
        };
        if (_iteration >= _max_iterations) then {
            if (_logging) then {
                [
                    format [
                        "jib_ao__cluster_kmeans: "
                            + "Limit (%1 iterations, %2 sec).",
                        _iteration + 1, uiTime - _start_time
                    ]
                ] call jib_ao__log;
            };
            break;
        };
        if (uiTime - _start_time >= _timeout) then {
            if (_logging) then {
                [
                    format [
                        "jib_ao__cluster_kmeans: "
                            + "Timeout (%1 iterations, %2 sec).",
                        _iteration + 1, uiTime - _start_time
                    ]
                ] call jib_ao__log;
            };
            break;
        };
        _iteration = _iteration + 1;
    };
    _partitions;
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
        _thisArgs params ["_clusters", "_draw_distance"];
        if (not isNull findDisplay 49) exitWith {}; // Pause menu
        if (isNull curatorCamera) exitWith {};
        for "_i" from 0 to count _clusters - 1 do {
            private _cluster = _clusters # _i;
            _cluster params [
                "_cluster_points", "_cluster_centroid",
                "_cluster_group_data", "_cluster_group"
            ];
            if (count _cluster_centroid < 3) then {
                [
                    format ["jib_ao__cluster_draw: Empty cluster %1", _i]
                ] call jib_ao__log;
                continue;
            };
            if (
                isNull curatorCamera ||
                    {curatorCamera distance _cluster_centroid > _draw_distance}
            ) then {
                continue;
            };
            // Draw title
            private _icon = "\A3\ui_f\data\map\markers\military\dot_CA.paa";
            private _color = [0,1,0,.5];
            private _offset = jib_ao_cluster_draw_offset;
            private _shadow = false;
            private _iconSize = 1;
            private _textSize = 1;
            private _textFont = "RobotoCondensedBold";
            private _textAlign = "right";
            drawIcon3D [
                _icon,
                _color,
                _cluster_centroid vectorAdd [0, 0, _offset],
                _iconSize,
                _iconSize,
                0,
                format ["Cluster %1 (size %2)", _i, count _cluster_points],
                _shadow
                // _textSize,
                // _textFont,
                // _textAlign
            ];
            // Draw positions
            for "_j" from 0 to count _cluster_points - 1 do {
                private _cluster_point = _cluster_points # _j;
                _cluster_point params ["_pos", "_unit_data", "_unit"];
                drawIcon3D [
                    _icon,
                    _color,
                    _pos,
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
                    _cluster_centroid vectorAdd [0, 0, _offset],
                    _pos,
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
        [[[[0, 0, 0], "foo"]], [0, 0, 0], false, false],
        [[[[1, 1, 1], "bar"]], [1, 1, 1], false, false]
    ];
    private _merged = [_clusters, 1] call jib_ao__cluster_merge;
    if (count _merged != 2) then {
        throw format ["jib_ao__cluster_merge: bad count %1", count _merged];
    };

    // Test merge threshold 2
    ["jib_ao__cluster_merge test threshold 2"] call jib_ao__log;
    private _clusters = [
        [[[[0, 0, 0], "foo"]], [0, 0, 0], false, false],
        [[[[1, 1, 1], "bar"]], [1, 1, 1], false, false]
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

// Daemon to run on all clients
[[], {
    if (!isNil "jib_ao__daemon_handle") then {
        terminate jib_ao__daemon_handle;
    };
    jib_ao__daemon_handle = [] spawn {
        scriptName "jib_ao__daemon";
        while {true} do {
            getAssignedCuratorLogic player setPos getPos curatorCamera;
            uiSleep 1;
        };
    };
}] remoteExec ["spawn", 0];
