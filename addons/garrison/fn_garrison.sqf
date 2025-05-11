jib_garrison_acre_setUnitLoadout;
jib_garrison_sleep_delay = 0.2;
jib_garrison_debug = false;

jib_garrison_trigger_read = {
    params [
        "_trigger",
        ["_filter_unit", {_x isKindOf "Man"}, [{}]]
    ];
    [
        [_trigger, _filter_unit] call jib_garrison__get_filter_trigger
    ] call jib_garrison_serialize_units;
};

jib_garrison_trigger_write = {
    params [
        "_trigger",
        "_data",
        ["_n_units", 100, [0]],
        ["_n_buildings", 10, [0]],
        ["_n_positions", 20, [0]],
        ["_filter_building", {count(_x buildingPos -1) > 4}, [{}]],
        ["_unit_init", {params ["_unit"];}, [{}]],
        ["_group_init", {
            params ["_group"];
            [
                _group, 1, 2, 3, random[0, 0.7, 1], random [0, 10, 200], 2
            ] call jib_ai_cqb;
        }, [{}]]
    ];
    [
        [_trigger, _filter_building] call jib_garrison__get_filter_trigger,
        _data,
        _n_units,
        _n_buildings,
        _n_positions,
        _unit_init,
        _group_init
    ] call jib_garrison_buildings_data;
};

jib_garrison_radius_read = {
    params [
        "_pos",
        ["_radius", 100, [0]],
        ["_filter_unit", {_x isKindOf "Man"}, [{}]]
    ];
    [
        _pos nearObjects _radius select _filter_unit
    ] call jib_garrison_serialize_units;
};

jib_garrison_radius_write = {
    params [
        "_pos",
        "_data",
        ["_radius", 100, [0]],
        ["_n_units", 100, [0]],
        ["_n_buildings", 10, [0]],
        ["_n_positions", 20, [0]],
        ["_filter_building", {count(_x buildingPos -1) > 4}, [{}]],
        ["_unit_init", {
            params ["_unit"];
            _unit setVariable ["jib_garrison", true, true];
        }, [{}]],
        ["_group_init", {
            params ["_group"];
            [
                _group, 1, 2, 3, random[0, 0.7, 1], random [0, 10, 200], 2
            ] call jib_ai_cqb;
        }, [{}]]
    ];
    [
        _pos nearObjects _radius select _filter_building,
        _data,
        _n_units,
        _n_buildings,
        _n_positions,
        _unit_init,
        _group_init
    ] call jib_garrison_buildings_data;
};

jib_garrison_trigger = {
    params [
        "_trigger",
        ["_n_units", 100, [0]],
        ["_n_buildings", 10, [0]],
        ["_n_positions", 20, [0]],
        ["_filter_building", {count(_x buildingPos -1) > 4}, [{}]],
        ["_filter_unit", {_x isKindOf "Man"}, [{}]],
        ["_unit_init", {params ["_unit"];}, [{}]],
        ["_group_init", {
            params ["_group"];
            [
                _group, 1, 2, 3, random[0, 0.7, 1], random [0, 10, 200], 2
            ] call jib_ai_cqb;
        }, [{}]]
    ];
    [
        _trigger,
        [_trigger, _filter_unit] call jib_garrison_trigger_read,
        _n_units,
        _n_buildings,
        _n_positions,
        _filter_building,
        _unit_init,
        _group_init
    ] call jib_garrison_trigger_write;
};

jib_garrison_radius = {
    params [
        "_pos",
        ["_radius", 100, [0]],
        ["_n_units", 100, [0]],
        ["_n_buildings", 10, [0]],
        ["_n_positions", 20, [0]],
        ["_filter_building", {count(_x buildingPos -1) > 4}, [{}]],
        ["_filter_unit", {_x isKindOf "Man"}, [{}]],
        ["_unit_init", {
            params ["_unit"];
            _unit setVariable ["jib_garrison", true, true];
        }, [{}]],
        ["_group_init", {
            params ["_group"];
            [
                _group, 1, 2, 3, random[0, 0.7, 1], random [0, 10, 200], 2
            ] call jib_ai_cqb;
        }, [{}]]
    ];
    [
        _pos,
        [_pos, _radius, _filter_unit] call jib_garrison_radius_read,
        _radius,
        _n_units,
        _n_buildings,
        _n_positions,
        _filter_building,
        _unit_init,
        _group_init
    ] call jib_garrison_radius_write;
};

jib_garrison_buildings_data = {
    params [
        "_buildings",
        "_data",
        ["_n_units", 100, [0]],
        ["_n_buildings", 10, [0]],
        ["_n_positions", 20, [0]],
        ["_unit_init", {params ["_unit"];}, [{}]],
        ["_group_init", {
            params ["_group"];
            [
                _group, 1, 2, 3, random[0, 0.7, 1], random [0, 10, 200], 2
            ] call jib_ai_cqb;
        }, [{}]]
    ];
    if (not canSuspend) then {throw "Cannot suspend."};
    if (count _buildings == 0) exitWith {
        ["No buildings."] call jib_garrison__log
    };
    if (count _data == 0) exitWith {
        ["No data."] call jib_garrison__log
    };
    private _units = [];
    private _p_building = _n_buildings / (count _buildings max 1);
    _buildings apply {
        if (random 1 > _p_building) then {continue};
        private _groups = [];
        private _p_position = _n_positions / (count (_x buildingPos -1) max 1);
        _x buildingPos -1 apply {
            if (random 1 >= _p_position) then {continue};
            selectRandom _data params ["_groupData", "_unitData"];
            _groupData params [
                "_name",
                "_deleteWhenEmpty",
                "_side",
                "_formation",
                "_combatMode",
                "_speedMode",
                "_lambs_danger_disableGroupAI"
            ];
            private _group = grpNull;
            private _sideGroups = _groups select {side _x == _side};
            if (count _sideGroups > 0) then {
                _group = _sideGroups # 0;
            } else {
                _group = createGroup [_side, true];
                _groups pushBack _group;
            };
            _units pushBack (
                [_group, _unitData, _x] call jib_garrison__spawn_unit
            );
            uiSleep jib_garrison_sleep_delay;
        };
        _groups select {not isNull _x} apply {
            private _leader = objNull;
            units _x apply {
                if (isNull _leader) then {
                    _leader = _x;
                    continue;
                };
                if (
                    [
                        [
                            rank _x,
                            _x getVariable ["jib_garrison__leader", false]],
                        [
                            rank _leader,
                            _leader getVariable ["jib_garrison__leader", false]
                        ]
                    ] call jib_garrison__special_compare
                ) then {
                    _leader = _x;
                };
            };
            _leader getVariable "jib_garrison__groupData" params [
                "_name",
                "_deleteWhenEmpty",
                "_side",
                "_formation",
                "_combatMode",
                "_speedMode",
                "_lambs_danger_disableGroupAI"
            ];
            _x deleteGroupWhenEmpty _deleteWhenEmpty;
            _x setFormation _formation;
            _x setCombatMode _combatMode;
            _x setSpeedMode _speedMode;
            _x selectLeader _leader;
            _x setVariable [
                "lambs_danger_disableGroupAI", _lambs_danger_disableGroupAI
            ];
            [_x] call _group_init;
            uiSleep jib_garrison_sleep_delay;
            units _x apply {
                _x setPosATL (_x getVariable "jib_garrison__posAGL");
                uiSleep jib_garrison_sleep_delay;
                _x allowDamage (_x getVariable "jib_garrison__damage");
                [_x, true] remoteExec ["enableSimulationGlobal", 2];
                [_x] call _unit_init;
                uiSleep jib_garrison_sleep_delay;
            };
        };
    };
    _units = _units apply {vehicle _x};
    _units = _units arrayIntersect _units;
    private _p = _n_units / (count _units max 1);
    _units select {random 1 > _p} apply {
        [_x] join grpNull;
        private _veh = vehicle _x;
        deleteVehicleCrew _veh;
        deleteVehicle _veh;
    };
    if (jib_garrison_debug) then {
        systemChat "Garrison done.";
    };
};

jib_garrison_serialize_units = {
    params ["_units"];
    private _data = _units apply {
        [
            [
                groupId group _x,
                true, // isGroupDeletedWhenEmpty
                side group _x,
                formation group _x,
                combatMode group _x,
                speedMode group _x,
                group _x getVariable ["lambs_danger_disableGroupAI", false]
            ],
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
                _x getVariable ["jib_garrison_allowFleeing", 0], // HACK
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
        ];
    };
    _units apply {
        [_x] join grpNull;
        private _veh = vehicle _x;
        deleteVehicleCrew _veh;
        deleteVehicle _veh;
    };
    _data;
};

jib_garrison__spawn_unit = {
    params [
        "_group",
        "_unitData",
        "_posAGL"
    ];
    _unitData params [
        "_type",
        "_posSerial",
        "_direction",
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
    private _unit = _group createUnit [
        _type, _posAGL, [], 0, "NONE"
    ];
    [_unit] joinSilent _group;
    _unit allowDamage false;
    [_unit, false] remoteExec ["enableSimulationGlobal", 2];
    _unit setVariable ["jib_garrison__damage", _isDamageAllowed];
    _unit setVariable ["jib_garrison__leader", _leader];
    _unit setVariable ["jib_garrison__posAGL", _posAGL];
    _unit setVariable ["jib_garrison__groupData", _groupData];
    [_unit] call jib_garrison__curator_register;
    _unit setDir _direction;
    _unit setRank _rank;
    _unit setSkill _skill;
    _unit setCombatBehaviour _combatBehaviour;
    _unit setUnitCombatMode _combatMode;
    [_unit, _loadout] call jib_garrison_acre_setUnitLoadout;
    _unit triggerDynamicSimulation _canTriggerDynamicSimulation;
    if (_fleeing != -1) then {
        _unit allowFleeing _fleeing;
        _unit setVariable ["jib_garrison_fleeing", _fleeing]; // debug
    };
    _unit setVariable ["lambs_danger_disableAI", _lambs_danger_disableAI];
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
    _unit;
};

jib_garrison__get_filter_trigger = {
    params [
        "_trigger",
        ["_filter", {true}, [{}]]
    ];
    private _posATL = getPosATL _trigger;
    triggerArea _trigger params ["_a", "_b", "_angle", "_isRect", "_c"];
    (
        _posATL nearObjects (_a max _b) * 1.42
    ) inAreaArray [_posATL] + triggerArea _trigger select {
        [_x] call _filter
    };
};

jib_garrison__get_filter_location = {
    params [
        "_location",
        ["_filter", {true}, [{}]]
    ];
    private _pos = getPos _location;
    size _location params ["_a", "_b"];
    private _angle = direction _location;
    private _isRect = rectangular _location;
    (
        _pos nearObjects (_a max _b) * 1.42
    ) inAreaArray _location select {
        [_x] call _filter
    };
};

jib_garrison__rank_compare = {
    params ["_a", "_b"];
    private _ranks = [
        "PRIVATE",
        "CORPORAL",
        "SERGEANT",
        "LIEUTENANT",
        "CAPTAIN",
        "MAJOR",
        "COLONEL"
    ];
    (_ranks findIf {_x == _a}) > (_ranks findIf {_x == _b});
};

jib_garrison__special_compare = {
    params ["_a", "_b"];
    _a params ["_a_rank", "_a_leader"];
    _b params ["_b_rank", "_b_leader"];
    if (_a_rank == _b_rank) then {
        _a_leader and not _b_leader;
    } else {
        [_a_rank, _b_rank] call jib_garrison__rank_compare;
    };
};

jib_garrison__curator_register = {
    params ["_object"];
    if (jib_garrison_debug) then {
        // NOTE: Called frequently, may cause network bottleneck
        [[_object], {
            params ["_object"];
            allCurators apply {
                _x addCuratorEditableObjects [[_object], false];
            };
        }] remoteExec ["spawn", 2];
    };
};

jib_garrison__log = {
    params ["_message"];
    diag_log format ["jib_garrison: %1", _message];
};
