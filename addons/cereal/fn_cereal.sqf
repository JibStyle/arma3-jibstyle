jib_cereal_loadout;

jib_cereal_delay_physics = 0.3;
publicVariable "jib_cereal_delay_physics";
jib_cereal_debug = false;
publicVariable "jib_cereal_debug";

jib_cereal_deserialize_batch = {
    params [
        "_serializedBatch",
        ["_pos", nil, [[]]]
    ];
    _serializedBatch params [
        "_serializedVehicles",
        "_serializedGroups",
        "_serializedSeats"
    ];
    private _vehicles = _serializedVehicles apply {
        [_x, _pos] call jib_cereal__deserialize_vehicle;
    };
    private _groups = _serializedGroups apply {
        [_x, _pos] call jib_cereal__deserialize_group;
    };
    [
        _vehicles, _groups apply {units _x}, _serializedSeats
    ] call jib_cereal__deserialize_seats;
    private _batch = [_vehicles, _groups];

    uiSleep jib_cereal_delay_physics;
    _vehicles apply {
        _x allowDamage (_x getVariable ["jib_cereal__damage", true])
    };
    _groups apply {
        units _x apply {
            _x allowDamage (_x getVariable ["jib_cereal__damage", true])
        }
    };
    [[_vehicles, _groups], {
        params ["_vehicles", "_groups"];
        _vehicles apply {_x enableSimulationGlobal true};
        _groups apply {units _x apply {_x enableSimulationGlobal true}};
    }] remoteExec ["spawn", 2];

    _batch;
};

jib_cereal_deserialize_crate = {
    uiSleep jib_cereal_delay_physics;
    params ["_serializedCrate"];
    _serializedCrate params [
        "_type", "_pos", "_direction",
        "_isDamageAllowed","_serializedInventory"
    ];

    private _crate =
        createVehicle [_type, _pos, [], 0, "NONE"];
    _crate allowDamage false;
    [_crate, false] remoteExec ["enableSimulationGlobal", 2];
    [_crate] call jib_cereal__curator_register;
    _crate setDir _direction;
    [
        _crate, _serializedInventory
    ] call jib_cereal__deserialize_inventory;

    uiSleep jib_cereal_delay_physics;
    _crate allowDamage _isDamageAllowed;
    [_crate, true] remoteExec ["enableSimulationGlobal", 2];
    _crate;
};

jib_cereal_deserialize_partial_batch = {
    params [
        "_group", "_vehicle_pos", "_soldier_pos",
        "_serialized_vehicles", "_serialized_soldiers", "_serialized_seats"
    ];
    private _vehicles = _serialized_vehicles apply {
        [_x, _vehicle_pos] call jib_cereal__deserialize_vehicle;
    };
    private _soldiers = [];
    _serialized_soldiers apply {
        _soldiers pushBack (
            [_group, _x, _soldier_pos] call jib_cereal__deserialize_soldier
        );
    };
    [
        _vehicles, [_soldiers], _serialized_seats
    ] call jib_cereal__deserialize_seats;
    uiSleep jib_cereal_delay_physics;
    _vehicles + _soldiers apply {
        _x allowDamage (_x getVariable ["jib_cereal__damage", true]);
    };
    [[_vehicles + _soldiers], {
        params ["_objects"];
        _objects apply {_x enableSimulationGlobal true};
    }] remoteExec ["spawn", 2];
    [_vehicles, _soldiers];
};

jib_cereal_deserialize_waypoint = {
    params ["_group", "_serializedWaypoint"];
    _serializedWaypoint params [
        "_pos",
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
    _group addWaypoint [_pos, _radius];
    [_group, _index] setWaypointType _type;
    [_group, _index] setWaypointFormation _formation;
    [_group, _index] setWaypointBehaviour _behaviour;
    [_group, _index] setWaypointCombatMode _combatMode;
    [_group, _index] setWaypointSpeed _speed;
    [_group, _index] setWaypointTimeout _timeout;
    [_group, _index] setWaypointStatements _statements;
    [_group, _index];
};

jib_cereal_serialize_batch = {
    params ["_vehicles", "_groups"];
    private _serializedVehicles =
        _vehicles apply {[_x] call jib_cereal_serialize_vehicle};
    private _serializedGroups =
        _groups apply {[_x] call jib_cereal__serialize_group};
    private _serializedSeats =
        [_vehicles, _groups] call jib_cereal__serialize_seats;
    [_serializedVehicles, _serializedGroups, _serializedSeats];
};

jib_cereal_serialize_crate = {
    params ["_crate"];
    [
        typeOf _crate,
        getPos _crate,
        direction _crate,
        isDamageAllowed _crate,
        [_crate] call jib_cereal__serialize_inventory
    ];
};

jib_cereal_serialize_soldier = {
    params ["_soldier"];
    [
        typeOf _soldier,
        getPos _soldier,
        direction _soldier,
        rank _soldier,
        skill _soldier,
        combatBehaviour _soldier,
        combatMode _soldier,
        getUnitLoadout _soldier,
        canTriggerDynamicSimulation _soldier,
        isDamageAllowed _soldier,
        leader _soldier == _soldier,
        _soldier getVariable ["jib_cereal__fleeing", 0], // HACK
        _soldier getVariable ["lambs_danger_disableAI", false],
        [
            _soldier skill "aimingAccuracy",
            _soldier skill "aimingShake",
            _soldier skill "aimingSpeed",
            _soldier skill "endurance",
            _soldier skill "spotDistance",
            _soldier skill "spotTime",
            _soldier skill "courage",
            _soldier skill "reloadSpeed",
            _soldier skill "commanding",
            _soldier skill "general"
        ]
    ];
};

jib_cereal_serialize_vehicle = {
    params ["_vehicle"];
    [
        typeOf _vehicle,
        getPos _vehicle,
        direction _vehicle,
        isDamageAllowed _vehicle,
        if (isTouchingGround _vehicle) then {"NONE"} else {"FLY"},
        [_vehicle] call jib_cereal__serialize_inventory
    ];
};

jib_cereal_serialize_waypoint_manual = {
    params [
        "_pos",
        ["_radius", 0, [0]],
        ["_type", "MOVE", [""]],
        ["_formation", "NO CHANGE", [""]],
        ["_behaviour", "UNCHANGED", [""]],
        ["_combatMode", "NO CHANGE", [""]],
        ["_speed", "UNCHANGED", [""]],
        ["_timeout", [0, 0, 0], [[]]],
        ["_statements", ["true", ""], [[]]]
    ];
    [
        _pos,
        _radius,
        _type,
        _formation,
        _behaviour,
        _combatMode,
        _speed,
        _timeout,
        _statements
    ];
};

jib_cereal__deserialize_group = {
    params ["_serializedGroup", ["_pos", nil, [[]]]];
    _serializedGroup params [
        "_name",
        "_deleteWhenEmpty",
        "_side",
        "_formation",
        "_combatMode",
        "_speedMode",
        "_serializedUnits",
        "_serializedWaypoints",
        "_lambs_danger_disableGroupAI"
    ];
    private _group = createGroup [_side, _deleteWhenEmpty];
    // _group setGroupIdGlobal [format "%1 %2", _name, random 1];
    _group setFormation _formation;
    _group setCombatMode _combatMode;
    _group setSpeedMode _speedMode;
    _serializedUnits apply {
        [_group, _x, _pos] call jib_cereal__deserialize_soldier;
    };
    units _group apply {
        if (_x getVariable ["jib_cereal__leader", false]) then {
            _group selectLeader _x;
        };
    };
    _serializedWaypoints apply {
        [_group, _x] call jib_cereal_deserialize_waypoint;
    };
    _group setVariable [
        "lambs_danger_disableGroupAI", _lambs_danger_disableGroupAI
    ];
    _group;
};

jib_cereal__deserialize_inventory = {
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
publicVariable "jib_cereal__deserialize_inventory";

jib_cereal__deserialize_seats = {
    uiSleep jib_cereal_delay_physics;
    params ["_vehicles", "_groups", "_serializedSeats"];
    _serializedSeats apply {
        _x params [
            "_vehicleIndex", "_groupIndex", "_unitIndex",
            "_role", "_cargoIndex", "_turretPath", "_personTurret"
        ];
        // TODO: Try addVehicle, see if fixes some guys dismounting
        private _vehicle = _vehicles # _vehicleIndex;
        private _soldier = _groups # _groupIndex # _unitIndex;
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
publicVariable "jib_cereal__deserialize_seats";

jib_cereal__deserialize_soldier = {
    uiSleep jib_cereal_delay_physics;
    params [
        "_group",
        "_serializedSoldier",
        "_posArg" // Optional
    ];
    _serializedSoldier params [
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
    private _pos = if (
        isNil {_posArg} || {count _posArg == 0}
    ) then {_posSerial} else {_posArg};
    private _soldier = _group createUnit [
        _type, [_pos # 0, _pos # 1, 0], [], 0, "NONE"
    ];
    [_soldier] joinSilent _group;
    _soldier allowDamage false;
    [_soldier, false] remoteExec ["enableSimulationGlobal", 2];
    _soldier setVariable ["jib_cereal__damage", _isDamageAllowed];
    _soldier setVariable ["jib_cereal__leader", _leader];
    [_soldier] call jib_cereal__curator_register;
    _soldier setDir _direction;
    _soldier setRank _rank;
    _soldier setSkill _skill;
    _soldier setCombatBehaviour _combatBehaviour;
    _soldier setUnitCombatMode _combatMode;
    [_soldier, _loadout] call jib_cereal_loadout;
    _soldier triggerDynamicSimulation _canTriggerDynamicSimulation;
    if (_fleeing != -1) then {
        _soldier allowFleeing _fleeing;
        _soldier setVariable ["jib_cereal__fleeing", _fleeing]; // debug
    };
    _soldier setVariable ["lambs_danger_disableAI", _lambs_danger_disableAI];
    _soldier setSkill ["aimingAccuracy", _skill_aimingAccuracy];
    _soldier setSkill ["aimingShake", _skill_aimingShake];
    _soldier setSkill ["aimingSpeed", _skill_aimingSpeed];
    _soldier setSkill ["endurance", _skill_endurance];
    _soldier setSkill ["spotDistance", _skill_spotDistance];
    _soldier setSkill ["spotTime", _skill_spotTime];
    _soldier setSkill ["courage", _skill_courage];
    _soldier setSkill ["reloadSpeed", _skill_reloadSpeed];
    _soldier setSkill ["commanding", _skill_commanding];
    _soldier setSkill ["general", _skill_general];
    _soldier;
};
publicVariable "jib_cereal__deserialize_soldier";

jib_cereal__deserialize_vehicle = {
    uiSleep jib_cereal_delay_physics;
    params ["_serializedVehicle", "_posArg"];
    _serializedVehicle params [
        "_type", "_posSerial", "_direction",
        "_isDamageAllowed", "_special", "_serializedInventory"
    ];
    private _pos = if (
        isNil {_posArg} || {count _posArg == 0}
    ) then {_posSerial} else {_posArg};
    private _vehicle = createVehicle [_type, _pos, [], 0, _special];
    _vehicle allowDamage false;
    [_vehicle, false] remoteExec ["enableSimulationGlobal", 2];
    _vehicle setVariable ["jib_cereal__damage", _isDamageAllowed];
    [_vehicle] call jib_cereal__curator_register;
    _vehicle setDir _direction;
    [
        _vehicle, _serializedInventory
    ] call jib_cereal__deserialize_inventory;
    // Hack to fix planes
    if (_vehicle isKindOf "Plane") then {
        [_vehicle] spawn {
            params ["_vehicle"];
            waitUntil {
                uiSleep jib_cereal_delay_physics;
                !alive _vehicle || alive driver _vehicle;
            };
            [_vehicle, 10, 0] call BIS_fnc_setPitchBank;
            _vehicle setVelocityModelSpace [0, 200, 0];
        }
    };
    _vehicle;
};
publicVariable "jib_cereal__deserialize_vehicle";

jib_cereal__serialize_group = {
    params ["_group"];
    [
        groupId _group,
        true, // isGroupDeletedWhenEmpty
        side _group,
        formation _group,
        combatMode _group,
        speedMode _group,
        units _group apply {
            [_x] call jib_cereal_serialize_soldier;
        },
        // TODO: Maybe include initial WP to enable cycle WP
        waypoints _group select [
            1, count waypoints _group - 1
        ] apply {
            _x call jib_cereal__serialize_waypoint;
        },
        _group getVariable ["lambs_danger_disableGroupAI", false]
    ];
};

jib_cereal__serialize_inventory = {
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

jib_cereal__serialize_seats = {
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

jib_cereal__serialize_waypoint = {
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

jib_cereal__curator_register = {
    params ["_object"];
    if (jib_cereal_debug) then {
        // NOTE: Called frequently, may cause network bottleneck
        [[_object], {
            params ["_object"];
            allCurators apply {
                _x addCuratorEditableObjects [[_object], false];
            };
        }] remoteExec ["spawn", 2];
    };
};
publicVariable "jib_cereal__curator_register";
