if (!isServer) exitWith {};

// Time between unit jumps
jib_para_interval = 0.2;

// AI units invincible while in air.
//
// Workaround because they magically die a lot.
jib_para_invincible = true;

jib_para_chute = "Steerable_Parachute_F";
publicVariable "jib_para_chute";

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

// Variable for saving vehicle lights.
jib_para_varLights = "jib_para_varLights";

// Transport ingress (all)
//
// Turn on red lights, wait, then open door.
jib_para_effectIngress = {
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
            if (_vehicle isKindOf _xType) then {
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
            if (_vehicle isKindOf _xType) then {
                _doors = _xDoors;
                break;
            };
        };
        _vehicle animateDoor _doors # 0;
    };
};

// Transport unload (all)
//
// Turn on green lights.
jib_para_effectDropzone = {
    params ["_group"];

    // Lights
    [_group] call jib_para_assignedVehicles apply {
        private _vehicle = _x;
        private _color = [0,1,0];
        _vehicle getVariable jib_para_varLights apply {
            _x setLightColor _color;
            _x setLightAmbient _color;
        };
    };
};

// Transport cleanup (all).
//
// Close door, wait, then delete lights.
jib_para_effectEgress = {
    params ["_group"];
    if (!canSuspend) then {throw "Not in scheduled environment!"};
    [_group] call jib_para_assignedVehicles apply {
        private _vehicle = _x;
        private _doors = [["", 0], ["", 0]];

        // Door
        jib_para_doors apply {
            _x params ["_xType", "_xDoors"];
            if (_vehicle isKindOf _xType) then {
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

// Collect and unload cargo (server).
jib_para_unload = {
    params ["_group", "_height"];
    if (!isServer) then {throw "Not server!"};
    [_group] call jib_para_cargoCollect apply {
        _x params ["_vehicle", "_groupsUnits", "_groupsCargo"];
        [
            _vehicle,
            _groupsUnits,
            _groupsCargo,
            _height
        ] spawn jib_para_cargoUnload;
    };
};

// PRIVATE

// Collect vehicles, groups, and units to unload (server).
jib_para_cargoCollect = {
    params ["_group"];
    if (!isServer) then {throw "Not server!"};
    private _vehiclesGroupsUnitsGroupsCargo = [];

    // Collect vehicles
    [_group] call jib_para_assignedVehicles apply {

        // Collect groups
        private _vehicle = _x;
        private _cargo = crew _vehicle select {
            _x in units group driver _vehicle == false;
        };
        private _groups = [];
        _cargo apply {_groups pushBackUnique group _x};
        private _groupsSorted =
            [_groups, [], {groupId _x}] call BIS_fnc_sortBy;

        // Collect units
        private _groupsUnits = _groupsSorted apply {
            [_x, units _x select {_x in _cargo}];
        };

        // Collect cargo groups
        _cargo = getVehicleCargo _vehicle;
        _groups = [];
        _cargo apply {_groups pushBackUnique group _x};
        _groupsSorted =
            [_groups, [], {groupId _x}] call BIS_fnc_sortBy;

        // Collect cargo units
        private _groupsCargo = _groupsSorted apply {
            [
                _x,
                [_x] call jib_para_assignedVehicles select {
                    _x in _cargo;
                }
            ];
        };

        // Push result
        _vehiclesGroupsUnitsGroupsCargo pushBack [
            _vehicle,
            _groupsUnits,
            _groupsCargo
        ];
    };
    _vehiclesGroupsUnitsGroupsCargo;
};

// Unload specific cargo (server).
jib_para_cargoUnload = {
    params ["_vehicle", "_groupsUnits", "_groupsCargo", "_height"];
    if (!isServer) then {throw "Not server!"};
    if (!canSuspend) then {throw "Not in scheduled environment!"};

    // Vehicle in vehicle
    _vehicle setVehicleCargo objNull;
    _groupsCargo apply {
        _x params ["_group", "_cargo"];
        [
            _vehicle,
            _group,
            _cargo
        ] remoteExec ["jib_para_regroup", leader _group];
    };

    // Infantry
    _groupsUnits apply {

        // Make units jump
        _x params ["_group", "_units"];
        _units apply {
            private _unit = _x;
            [_unit, _height, jib_para_invincible] remoteExec [
                "jib_para_jump", _unit
            ];
            uiSleep jib_para_interval;
        };

        // Make units regroup
        [
            _vehicle,
            _group,
            _units
        ] remoteExec ["jib_para_regroup", leader _group];
    };
};

// Regroup units when they land.
jib_para_regroup = {
    params ["_vehicle", "_group", "_units"];
    if (!canSuspend) then {throw "Not in scheduled environment!"};
    _group leaveVehicle _vehicle;
    doStop _units;
    waitUntil {
        getPosATL vehicle leader _group # 2 < 10
    };
    _units doFollow leader _group;
};

// Get group assigned vehicles (all)
//
// NOTE: `assignedVehicles` engine command to be released in v2.12.
jib_para_assignedVehicles = {
    params ["_group"];
    private _vehicles = [];
    units _group apply {
        private _vehicle = assignedVehicle _x;
        if (not isNull _vehicle) then {
            _vehicles pushBackUnique _vehicle;
        };
    };
    _vehicles;
};

// Unit paradrop (local)
//
// Jump out from vehicle and auto deploy parachute.
jib_para_jump = {
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
        jib_para_chute,
        getPosATL _unit
    ];
    [_unit, _invincible] spawn {
        params ["_unit", "_invincible"];
        uiSleep 3;
        if (isPlayer _unit || not _invincible) then {
            _unit allowDamage true;
        };
    };
    waitUntil { position _unit # 2 < 5 };
    if (!isPlayer _unit) then {
        _unit allowDamage false;
    };
    waitUntil { isTouchingGround _unit };
    uiSleep 3;
    _unit allowDamage true;
    [_unit] allowGetIn true;
};

publicVariable "jib_para_varLights";
publicVariable "jib_para_lights";
publicVariable "jib_para_doors";
publicVariable "jib_para_effectIngress";
publicVariable "jib_para_effectDropzone";
publicVariable "jib_para_effectEgress";
publicVariable "jib_para_assignedVehicles";
publicVariable "jib_para_jump";
publicVariable "jib_para_regroup";
