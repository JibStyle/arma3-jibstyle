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

// Cluster and return points into given cluster max sizes.
//
// If more positions than cluster slots, excess positions will be discarded. If
// fewer positions than cluster slots, excess clusters will be discarded.
jib_ao__cluster_generate = {
    // Setup
    params [
        "_positions",
        "_sizes",
        ["_max_iterations", 100, [0]],
        ["_min_delta", 0.1, [0]]
    ];
    private _slots = count _positions;
    _sizes = _sizes select {
        _slots = _slots - _x;
        _slots >= 0;
    };
    _positions = _positions apply {[random 1, _x]};
    _positions sort false;
    _positions = _positions apply {_x # 1};
    private _centroids = _positions select [0, count _sizes];
    private _iteration = 0;
    private _clusters = [];
    while {true} do {
        // Iteration setup
        _iteration = _iteration + 1;
        if (_iteration >= _max_iterations) then {
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
                        && count (_clusters # _i) < _sizes # _i
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
    params ["_clusters"];
    if (!isNil "jib_ao__cluster_draw_handle") then {
        removeMissionEventHandler ["Draw3D", jib_ao__cluster_draw_handle];
    };
    jib_ao__cluster_draw_handle = addMissionEventHandler ["Draw3D", {
        private _clusters = _thisArgs;
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
    }, _clusters];
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
