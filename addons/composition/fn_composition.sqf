jib_composition_sleep_delay = .1;
jib_composition_sleep_delay_physics = 5;
jib_composition_debug = true;
jib_composition_default_radius = 100;
jib_composition_altitude_tolerance = 5;

jib_composition_radius_read = {
    params [
        "_pos",
        ["_radius", jib_composition_default_radius, [0]]
    ];
    (
        (8 allObjects 0) + ((8 allObjects 1) arrayIntersect vehicles)
    ) select {_x distance _pos < _radius} apply {
        [
            typeOf _x,
            getPosATL _x vectorDiff _pos,
            direction _x,
            vectorDir _x,
            vectorUp _x,
            isDamageAllowed _x,
            simulationEnabled _x,
            isObjectHidden _x,
            damage _x
        ]
    };
};

jib_composition_write = {
    params [
        "_pos",
        "_dir",
        "_data"
    ];
    if (not canSuspend) exitWith {throw "Cannot suspend."};
    if (count _data == 0) exitWith {
        ["No data."] call jib_composition__log
    };
    private _objects = _data apply {
        _x params [
            "_type",
            "_pos_offset",
            "_direction",
            "_vector_dir",
            "_vector_up",
            "_is_damage_allowed",
            "_simulation_enabled",
            "_is_object_hidden",
            "_damage"
        ];
        private _position =
            _pos vectorAdd ([_pos_offset, -_dir] call BIS_fnc_rotateVector2D);
        _direction = _direction + _dir;
        _vector_dir = [_vector_dir, -_dir] call BIS_fnc_rotateVector2D;
        _vector_up = [_vector_up, -_dir] call BIS_fnc_rotateVector2D;
        private _object =
            createVehicle [_type, _position, [], 0, "CAN_COLLIDE"];
        _object allowDamage false;
        [_object , false] remoteExec ["enableSimulationGlobal", 2];
        _object setVariable [
            "jib_composition__is_damage_allowed", _is_damage_allowed];
        _object setVariable [
            "jib_composition__simulation_enabled", _simulation_enabled];
        [_object] call jib_composition__curator_register;
        _object hideObject _is_object_hidden;
        _object setDamage [_damage, false];
        _object setPos _position;
        if (
            (
                isTouchingGround _object
                    || getPos _object # 2 < jib_composition_altitude_tolerance
            ) && !(_object isKindOf "House")
        ) then {
            _object setDir _direction;
            _object setVectorUp surfaceNormal getPos _object;
        } else {
            _object setVectorDirAndUp [_vector_dir, _vector_up];
        };
        uiSleep jib_composition_sleep_delay;
        _object;
    };
    _objects apply {
        [
            _x, (_x getVariable "jib_composition__simulation_enabled")
        ] remoteExec ["enableSimulationGlobal", 2];
    };
    uiSleep jib_composition_sleep_delay_physics;
    _objects apply {
        _x allowDamage (_x getVariable "jib_composition__is_damage_allowed");
    };
    ["Write composition done."] call jib_composition__log;
};

jib_composition__curator_register = {
    params ["_object"];
    if (jib_composition_debug) then {
        // NOTE: Called frequently, may cause network bottleneck
        [[_object], {
            params ["_object"];
            allCurators apply {
                _x addCuratorEditableObjects [[_object], false];
            };
        }] remoteExec ["spawn", 2];
    };
};

jib_composition__log = {
    params ["_message"];
    diag_log format ["jib_composition: %1", _message];
    if (jib_composition_debug) then {
        systemChat format ["jib_composition: %1", _message];
    };
};
