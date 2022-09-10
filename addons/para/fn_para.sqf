if (!isServer) exitWith {};

// Variable for saving vehicle lights.
jib_para_varLights = "jib_para_varLights";

// Association list of vehicle type to array of light offsets
jib_para_lights = [
    ["VTOL_01_base_F", [
        [0, -3, -2],
        [0, -6, -2],
        [0, -9, -2],
        [0, -12, -2],
        [0, -15, -2]
    ]]
];

// Association list of vehicle type to door animations
jib_para_doors = [
    ["VTOL_01_base_F",
     [["Door_1_source", 1], ["Door_1_source", 0]]]
];

// Transport ingress (all)
//
// Turn on red lights, wait, then open door.
jib_para_ingress = {
    scriptName "jib_para_ingress";
    params ["_group"];
    if (!canSuspend) then {throw "Not in scheduled environment!"};
    [_group] call jib_para_assignedVehicles apply {

        // Vars
        private _vehicle = _x;
        private _brightness = 0.1;
        private _color = [1,0,0];
        private _offsets = [];
        private _lights = [];
        private _doors = [["", 0], ["", 0]];

        // Lights
        jib_para_lights apply {
            _x params ["_xType", "_xOffsets"];
            if (_vehicle isKindOf _type) then {
                _offsets = _xOffsets;
                break;
            };
        };
        _offsets apply {
            private _light = "#lightpoint" createVehicleLocal [0,0,0];
            _light attachTo [_vehicle, _x];
            _light setLightColor _color;
            _light setLightAmbient _color;
            _light setLightBrightness _brightness;
            _light setLightDayLight true;
            _lights pushBack _light;
        };
        _vehicle setVariable [jib_para_varLights, _lights];

        // Door
        uiSleep 2;
        jib_para_doors apply {
            _x params ["_xType", "_xDoors"];
            if (_vehicle isKindOf _type) then {
                _doors = _xDoors;
                break;
            };
        };
        _vehicle animateDoor _doors # 0;
    };
};

// Transport unload (all)
//
// Turn on green lights. If server, wait then unload cargo.
jib_para_unload = {
    scriptName "jib_para_unload";
    params ["_group", "_height"];
    if (!canSuspend) then {throw "Not in scheduled environment!"};
    private _interval = 0.3;
    private _invincible = false;

    // Lights
    [_group] call jib_para_assignedVehicles apply {
        private _vehicle = _x;
        private _color = [0,1,0];
        _vehicle getVariable jib_para_varLights apply {
            _x setLightColor _color;
            _x setLightAmbient _color;
        };
    };

    // Jump! (server)
    if (!isServer) exitWith {};
    uiSleep 1;
    [_group] call jib_para_assignedVehicles apply {

        // Unload vehicle in vehicle
        private _vehicle = _x;
        _vehicle setVehicleCargo objNull;

        // Collect groups and units
        private _cargo = crew _vehicle select {
            _x in units group effectiveCommander _vehicle == false;
        };
        private _groups = [];
        _cargo apply {_groups pushBackUnique group _x};
        private _groupsSorted =
            [_groups, [], {groupId _x}] call BIS_fnc_sortBy;
        private _groupsAndUnits = _groupsSorted apply {
            [_x, units _x select {_x in _cargo}];
        };
        _groupsAndUnits apply {

            // Make units jump
            _x params [_group, _units];
            _units apply {
                private _unit = _x;
                [_unit, _height, _invincible] remoteExec [
                    "jib_para_jump", _unit
                ];
                uiSleep _interval;
            };
            [_group, _vehicle] remoteExec ["leaveVehicle", _group];
        };
    };
};

// Transport cleanup (all)
jib_para_egress = {
    scriptName "jib_para_egress";
    params ["_group"];
    if (!canSuspend) then {throw "Not in scheduled environment!"};
    [_group] call jib_para_assignedVehicles apply {
        private _vehicle = _x;

        // Door
        jib_para_doors apply {
            _x params ["_xType", "_xDoors"];
            if (_vehicle isKindOf _type) then {
                _doors = _xDoors;
                break;
            };
        };
        _vehicle animateDoor _doors # 1;

        // Lights
        uiSleep 2;
        _vehicle getVariable jib_para_varLights apply {
            deleteVehicle _x;
        };
        _vehicle setVariable [jib_para_varLights, nil];
    };
};

// Get group assigned vehicles (all)
//
// NOTE: `assignedVehicles` engine command to be released in v2.12.
jib_para_assignedVehicles = {
    scriptName "jib_para_assignedVehicles";
    params ["_group"];
    private _vehicles = [];
    units _group apply {
        _vehicles pushBackUnique assignedVehicle _x;
    };
};

// Unit paradrop (local)
//
// Jump out from vehicle and auto deploy parachute.
jib_para_jump = {
    scriptName "jib_para_jump";
    params ["_unit", "_height", "_invincible"];
    if (not local _unit) then {throw "Unit not local!"};
    _unit allowDamage false;
    moveOut _unit;
    unassignVehicle _unit;
    [_unit] allowGetIn false;
    // _unit action ["Eject", vehicle _unit];
    uiSleep 1;
    waitUntil {
        position _unit # 2 < _height;
    };
    _unit moveInDriver createVehicle [
        "Steerable_Parachute_F",
        getPosATL _unit
    ];
    [_unit, _invincible] spawn {
        params ["_unit", "_invincible"];
        uiSleep 1;
        if (isPlayer _unit || not _invincible) then {
            _unit allowDamage true;
        };
    };
    waitUntil { position _unit # 2 < 5 };
    if (!isPlayer _unit) then {
        _unit allowDamage false;
    };
    waitUntil { isTouchingGround _unit || position _unit # 2 < 1 };
    uiSleep 1;
    _unit allowDamage true;
    [_unit] allowGetIn true;
};

publicVariable "jib_para_varLights";
publicVariable "jib_para_lights";
publicVariable "jib_para_doors";
publicVariable "jib_para_ingress";
publicVariable "jib_para_unload";
publicVariable "jib_para_egress";
publicVariable "jib_para_assignedVehicles";
publicVariable "jib_para_jump";
