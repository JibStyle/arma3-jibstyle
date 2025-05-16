jib_garrison_acre_setUnitLoadout;
jib_garrison_sleep_delay = 0.1;
jib_garrison_debug = false;

// Default param values.
jib_garrison_default_radius = 100;
jib_garrison_default_n_units = [100, 100, 100, 20]; // BLU, IND, OPF, CIV
jib_garrison_default_p_interside = 0;
jib_garrison_default_p_building = {
    params ["_n_buildings"];
    10 / (_n_buildings max 1);
};
jib_garrison_default_p_position = {
    params ["_n_positions"];
    5 / (_n_positions max 1);
};
jib_garrison_default_filter_building = {
    params ["_building"];
    count(_building buildingPos -1) >= 4;
};
jib_garrison_default_filter_unit = {
    params ["_unit"];
    _unit in allUnits;
};
jib_garrison_default_unit_init = {
    params ["_unit"];
};
jib_garrison_default_group_init = {
    params ["_group"];
    [
        _group, 1, 2, 3, random[0, 0.7, 1], random [0, 10, 200], 2
    ] call jib_ai_cqb;
};

// Populate buildings in trigger area based on unit data.
jib_garrison_trigger_write = {
    params [
        "_trigger",
        "_data",
        ["_n_units", jib_garrison_default_n_units, [[], 0]],
        ["_p_building", jib_garrison_default_p_building, [{}, 0]],
        ["_p_position", jib_garrison_default_p_position, [{}, 0]],
        ["_p_interside", jib_garrison_default_p_interside, [0]],
        ["_filter_building", jib_garrison_default_filter_building, [{}, 0]],
        ["_unit_init", jib_garrison_default_unit_init, [{}]],
        ["_group_init", jib_garrison_default_group_init, [{}]]
    ];
    private _filter_building_result = _filter_building;
    if (typeName _filter_building == "SCALAR") then {
        _filter_building_result = {
            params ["_building"];
            count(_building buildingPos -1) >= _filter_building;
        };
    };
    [
        [_trigger] call jib_garrison__get_trigger_objects select {
            [_x] call _filter_building_result
        },
        _data,
        _n_units,
        _p_building,
        _p_position,
        _p_interside,
        _unit_init,
        _group_init
    ] call jib_garrison_buildings_data;
};

// Delete units in trigger area and return data.
jib_garrison_trigger_read = {
    params [
        "_trigger",
        ["_filter_unit", jib_garrison_default_filter_unit, [{}]]
    ];
    [
        [_trigger, _filter_unit] call jib_garrison__get_filter_trigger
    ] call jib_garrison_serialize_units;
};

// Populate buildings in radius based on unit data.
jib_garrison_radius_write = {
    params [
        "_pos",
        "_data",
        ["_radius", jib_garrison_default_radius, [0]],
        ["_n_units", jib_garrison_default_n_units, [[], 0]],
        ["_p_building", jib_garrison_default_p_building, [{}, 0]],
        ["_p_position", jib_garrison_default_p_position, [{}, 0]],
        ["_p_interside", jib_garrison_default_p_interside, [0]],
        ["_filter_building", jib_garrison_default_filter_building, [{}, 0]],
        ["_unit_init", jib_garrison_default_unit_init, [{}]],
        ["_group_init", jib_garrison_default_group_init, [{}]]
    ];
    private _filter_building_result = _filter_building;
    if (typeName _filter_building == "SCALAR") then {
        _filter_building_result = {
            params ["_building"];
            count(_building buildingPos -1) >= _filter_building;
        };
    };
    [
        _pos nearObjects _radius select {
            [_x] call _filter_building_result
        },
        _data,
        _n_units,
        _p_building,
        _p_position,
        _p_interside,
        _unit_init,
        _group_init
    ] call jib_garrison_buildings_data;
};

// Delete units in radius and return data.
jib_garrison_radius_read = {
    params [
        "_pos",
        ["_radius", jib_garrison_default_radius, [0]],
        ["_filter_unit", jib_garrison_default_filter_unit, [{}]]
    ];
    [
        _pos nearObjects _radius select _filter_unit
    ] call jib_garrison_serialize_units;
};

// Grab units and use to populate buildings in trigger area.
jib_garrison_trigger = {
    params [
        "_trigger",
        ["_n_units", jib_garrison_default_n_units, [[], 0]],
        ["_p_building", jib_garrison_default_p_building, [{}, 0]],
        ["_p_position", jib_garrison_default_p_position, [{}, 0]],
        ["_p_interside", jib_garrison_default_p_interside, [0]],
        ["_filter_building", jib_garrison_default_filter_building, [{}, 0]],
        ["_filter_unit", jib_garrison_default_filter_unit, [{}]],
        ["_unit_init", jib_garrison_default_unit_init, [{}]],
        ["_group_init", jib_garrison_default_group_init, [{}]]
    ];
    [
        _trigger,
        [_trigger, _filter_unit] call jib_garrison_trigger_read,
        _n_units,
        _p_building,
        _p_position,
        _p_interside,
        _filter_building,
        _unit_init,
        _group_init
    ] call jib_garrison_trigger_write;
};

// Grab units and use to populate buildings in radius.
jib_garrison_radius = {
    params [
        "_pos",
        ["_radius", jib_garrison_default_radius, [0]],
        ["_n_units", jib_garrison_default_n_units, [[], 0]],
        ["_p_building", jib_garrison_default_p_building, [{}, 0]],
        ["_p_position", jib_garrison_default_p_position, [{}, 0]],
        ["_p_interside", jib_garrison_default_p_interside, [0]],
        ["_filter_building", jib_garrison_default_filter_building, [{}, 0]],
        ["_filter_unit", jib_garrison_default_filter_unit, [{}]],
        ["_unit_init", jib_garrison_default_unit_init, [{}]],
        ["_group_init", jib_garrison_default_group_init, [{}]]
    ];
    [
        _pos,
        [_pos, _radius, _filter_unit] call jib_garrison_radius_read,
        _radius,
        _n_units,
        _p_building,
        _p_position,
        _p_interside,
        _filter_building,
        _unit_init,
        _group_init
    ] call jib_garrison_radius_write;
};

// Populate buildings based on unit data.
jib_garrison_buildings_data = {
    params [
        "_buildings",
        "_data",
        ["_n_units", jib_garrison_default_n_units, [[], 0]],
        ["_p_building", jib_garrison_default_p_building, [{}, 0]],
        ["_p_position", jib_garrison_default_p_position, [{}, 0]],
        ["_p_interside", jib_garrison_default_p_interside, [0]],
        ["_unit_init", jib_garrison_default_unit_init, [{}]],
        ["_group_init", jib_garrison_default_group_init, [{}]]
    ];
    if (not canSuspend) exitWith {throw "Cannot suspend."};
    if (count _buildings == 0) exitWith {
        ["No buildings."] call jib_garrison__log
    };
    if (count _data == 0) exitWith {
        ["No data."] call jib_garrison__log
    };
    private _units_west = [];
    private _units_east = [];
    private _units_independent = [];
    private _units_civilian = [];
    private _p_building_result = 0;
    if (typeName _p_building == "CODE") then {
        _p_building_result = [count _buildings] call _p_building;
    } else {
        _p_building_result = _p_building;
    };
    _buildings apply {
        if (random 1 > _p_building_result) then {continue};
        private _groups = [];
        private _interside = random 1 <= _p_interside;
        private _p_position_result = 0;
        if (typeName _p_position == "CODE") then {
            _p_position_result = [count (_x buildingPos -1)] call _p_position;
        } else {
            _p_position_result = _p_position;
        };
        _x buildingPos -1 apply {
            if (random 1 >= _p_position_result) then {continue};
            if (count _data == 0) exitWith {throw "No data"};
            private _filtered_data = _data select {
                _interside
                    || {count _groups == 0}
                    || {side (_groups # 0) == _x # 0 # 2};
            };
            if (count _filtered_data == 0) exitWith {
                throw "No filtered data";
            };
            selectRandom _filtered_data params ["_groupData", "_unitData"];
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
                if (isNull _group) exitWith {
                    throw "Group creation failed";
                };
                _groups pushBack _group;
            };
            private _unit =
                [_group, _unitData, _x] call jib_garrison__spawn_unit;
            switch _side do
            {
                case west: {_units_west pushBack _unit;};
                case independent: {_units_independent pushBack _unit;};
                case east: {_units_east pushBack _unit;};
                case civilian: {_units_civilian pushBack _unit;};
                default {["Invalid side."] call jib_garrison__log;};
            };
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
            _x deleteGroupWhenEmpty true; // true for now
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
    private _filter_units = {
        params ["_units", "_n"];
        _units = _units apply {vehicle _x};
        _units = _units arrayIntersect _units;
        private _p = _n / (count _units max 1);
        _units select {random 1 > _p} apply {
            [_x] join grpNull;
            private _veh = vehicle _x;
            private _group = group _x;
            deleteVehicleCrew _veh;
            deleteVehicle _veh;
            deleteGroup _group;
        };
    };
    if (typeName _n_units == "ARRAY") then {
        _n_units params [
            "_n_west", "_n_independent", "_n_east", "_n_civilian"
        ];
        [_units_west, _n_west] call _filter_units;
        [_units_independent, _n_independent] call _filter_units;
        [_units_east, _n_east] call _filter_units;
        [_units_civilian, _n_civilian] call _filter_units;
    } else {
        [
            _units_west + _units_independent + _units_east + _units_civilian,
            _n_units
        ] call _filter_units;
    };
    if (jib_garrison_debug) then {
        systemChat "Garrison done.";
    };
};

// Delete units and return their data.
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

jib_garrison__get_trigger_objects = {
    params ["_trigger"];
    private _posATL = getPosATL _trigger;
    triggerArea _trigger params ["_a", "_b", "_angle", "_isRect", "_c"];
    (
        _posATL nearObjects (_a max _b) * 1.42
    ) inAreaArray [_posATL] + triggerArea _trigger;
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
