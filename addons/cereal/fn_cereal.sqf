jib_cereal_delay_physics = 0.3;
jib_cereal_debug = true;

jib_cereal_deserialize_batch = {
    params ["_serializedBatch"];
    _serializedBatch params [
        "_serializedVehicles",
        "_serializedGroups",
        "_serializedSeats"
    ];
    // TODO: Try vehicles first with sim disabled
    private _groups = _serializedGroups apply {
        [_x] call jib_cereal__deserialize_group;
    };
    private _vehicles = _serializedVehicles apply {
        [_x] call jib_cereal__deserialize_vehicle;
    };
    [
        _vehicles, _groups, _serializedSeats
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
    [_crate] call jib_cereal__curator_register;
    _crate setDir _direction;
    [
        _crate, _serializedInventory
    ] call jib_cereal__deserialize_inventory;

    uiSleep jib_cereal_delay_physics;
    _crate allowDamage _isDamageAllowed;
    _crate;
};

jib_cereal_deserialize_soldiers = {
    params [
        "_group",
        "_serializedSoldiers",
        "_pos" // Optional
    ];
    private _soldiers = [];
    _serializedSoldiers apply {
        _soldiers pushBack (
            [_group, _x, _pos] call jib_cereal__deserialize_soldier
        );
    };
    uiSleep jib_cereal_delay_physics;
    _soldiers apply {
        _x allowDamage (_x getVariable ["jib_cereal__damage", true]);
    };
    _soldiers;
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
        _vehicles apply {[_x] call jib_cereal__serialize_vehicle};
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
        _soldier getVariable ["jib_cereal__fleeing", 0] // HACK
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
        [_group, _x] call jib_cereal__deserialize_soldier;
    };
    units _group apply {
        if (_x getVariable ["jib_cereal__leader", false]) then {
            _group selectLeader _x;
        };
    };
    _serializedWaypoints apply {
        [_group, _x] call jib_cereal_deserialize_waypoint;
    };
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
        "_fleeing"
    ];
    private _pos = if (
        isNil {_posArg} || {count _posArg == 0}
    ) then {_posSerial} else {_posArg};
    private _soldier = _group createUnit [
        _type, [_pos # 0, _pos # 1, 0], [], 0, "NONE"
    ];
    _soldier allowDamage false;
    _soldier setVariable ["jib_cereal__damage", _isDamageAllowed];
    _soldier setVariable ["jib_cereal__leader", _leader];
    [_soldier] call jib_cereal__curator_register;
    _soldier setDir _direction;
    _soldier setRank _rank;
    _soldier setSkill _skill;
    _soldier setCombatBehaviour _combatBehaviour;
    _soldier setUnitCombatMode _combatMode;
    _soldier setUnitLoadout _loadout; // TODO: Maybe refresh backpack
    _soldier triggerDynamicSimulation _canTriggerDynamicSimulation;
    if (_fleeing != -1) then {
        _soldier allowFleeing _fleeing;
        _soldier setVariable ["jib_cereal__fleeing", _fleeing]; // debug
    };
    _soldier;
};

jib_cereal__deserialize_vehicle = {
    uiSleep jib_cereal_delay_physics;
    params ["_serializedVehicle"];
    _serializedVehicle params [
        "_type", "_pos", "_direction",
        "_isDamageAllowed", "_special", "_serializedInventory"
    ];
    private _vehicle = createVehicle [_type, _pos, [], 0, _special];
    _vehicle allowDamage false;
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
        }
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

jib_cereal__serialize_vehicle = {
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
        allCurators apply {
            _x addCuratorEditableObjects [[_object], false];
        };
    };
};
