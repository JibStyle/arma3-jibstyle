// Setup paradrop waypoints.
#define WP_SPACING 100
#define VAR_START "jib_logistics_start"
#define VAR_DOORS "jib_logistics_paradrop_door"
#define VAR_LIGHTS "jib_logistics_paradrop_lights"
#define VAR_LIGHT_OFFSETS "jib_logistics_paradrop_lightOffsets"
#define VAR_LIGHT_BRIGHTNESS "jib_logistics_paradrop_lightBrightness"
#define VAR_HEIGHT "jib_logistics_paradrop_height"
#define VAR_INTERVAL "jib_logistics_paradrop_interval"
#define VAR_INVINCIBLE "jib_logistics_paradrop_invincible"
params [
    "_unit",                               // Aircraft
    ["_lightOffsets", [], [[]]],           // Light offsets
    ["_lightBrightness", [0, 0, 0], [[]]], // Light brightness [Y, R, G]
    ["_doors", [["", 0], ["", 0]], []],    // Door data
    ["_flyHeight", -1, [0]],               // Fly in height
    ["_paraHeight", 1e11, [0]],            // Chute open height
    ["_interval", 0.3, [0]],               // Jump interval
    ["_invincible", false, [true]]         // AI invincible
];
if (!isServer) then {throw "Not server!"};
if (!alive _unit) then {throw "Aircraft not alive!"};

// Vehicle setup
private _vehicle = vehicle _unit;
private _vehiclePosATL = getPosATL _vehicle;
private _vehicleGroup = group effectiveCommander _vehicle;
private _vehicleCurrentWP = count waypoints _vehicleGroup;
if (_flyHeight > 0) then {
    [_vehicle, _flyHeight] remoteExec ["flyInHeight", 0];
};
_vehicle setVariable [VAR_START, false, true];
_vehicle setVariable [VAR_DOORS, _doors, true];
_vehicle setVariable [VAR_LIGHT_OFFSETS, _lightOffsets, true];
_vehicle setVariable [VAR_LIGHT_BRIGHTNESS, _lightBrightness, true];
_vehicle setVariable [VAR_HEIGHT, _paraHeight, true];
_vehicle setVariable [VAR_INTERVAL, _interval, true];
_vehicle setVariable [VAR_INVINCIBLE, _invincible, true];

// WP 1: Wait
if (isNil "jib_logistics_paradrop_vehicleSetup") then {
    // Vehicle setup (all)
    jib_logistics_paradrop_vehicleSetup = {
        params ["_vehicle"];
        private _offsets = _vehicle getVariable VAR_LIGHT_OFFSETS;
        private _brightness = _vehicle getVariable VAR_LIGHT_BRIGHTNESS;
        private _lights = [];
        private _color = [1,1,0];
        {
            private _light = "#lightpoint" createVehicleLocal [0,0,0];
            _light attachTo [_vehicle, _x];
            _light setLightColor _color;
            _light setLightAmbient _color;
            _light setLightBrightness _brightness # 0;
            _light setLightDayLight true;
            _lights pushBack _light;
        } forEach _offsets;
        _vehicle setVariable [VAR_LIGHTS, _lights];
    };
    publicVariable "jib_logistics_paradrop_vehicleSetup";
};
if (isNil "jib_logistics_paradrop_wpWaitCondition") then {
    // Wait WP condition (local)
    jib_logistics_paradrop_wpWaitCondition = {
        params ["_group"];
        private _vehicle = vehicle leader _group;
        _vehicle getVariable [VAR_START, false];
    };
    publicVariable "jib_logistics_paradrop_wpWaitCondition";
};
if (isNil "jib_logistics_paradrop_wpWaitComplete") then {
    // Wait WP completion (server)
    jib_logistics_paradrop_wpWaitComplete = {
        params ["_group"];
        private _vehicle = vehicle leader _group;
        [_vehicle] remoteExec ["jib_logistics_paradrop_vehicleSetup", 0];
    };
};
private _wpIndex1 = _vehicleCurrentWP;
private _wpPosAGL1 = _vehiclePosATL vectorAdd (
    [
        [0, 1 * WP_SPACING, 0],
        direction _vehicle,
        2
    ] call BIS_fnc_rotateVector3D
);
_vehicleGroup addWaypoint [_wpPosAGL1, 0, _wpIndex1, "Jib Wait"];
[_vehicleGroup, _wpIndex1] setWaypointType "SCRIPTED";
[_vehicleGroup, _wpIndex1] setWaypointStatements [
    "[this] call jib_logistics_paradrop_wpWaitCondition",
    "[this] call jib_logistics_paradrop_wpWaitComplete"
];

// WP 2: Ingress
if (isNil "jib_logistics_paradrop_vehicleIngress") then {
    // Vehicle ingress (all)
    jib_logistics_paradrop_vehicleIngress = {
        params ["_vehicle"];
        private _doors = _vehicle getVariable VAR_DOORS;
        private _brightness = _vehicle getVariable VAR_LIGHT_BRIGHTNESS;
        private _color = [1,0,0];
        {
            _x setLightColor _color;
            _x setLightAmbient _color;
            _x setLightBrightness _brightness # 1;
        } forEach (_vehicle getVariable VAR_LIGHTS);
        uiSleep 2;
        _vehicle animateDoor _doors # 0;
    };
    publicVariable "jib_logistics_paradrop_vehicleIngress";
};
if (isNil "jib_logistics_paradrop_wpIngressComplete") then {
    // Ingress WP completion (server)
    jib_logistics_paradrop_wpIngressComplete = {
        params ["_group"];
        if (!isServer) then {throw "Not server!"};
        private _vehicle = vehicle leader _group;
        [_vehicle] remoteExec ["jib_logistics_paradrop_vehicleIngress", 0];
    };
};
private _wpIndex2 = _vehicleCurrentWP + 1;
private _wpPosAGL2 = _vehiclePosATL vectorAdd (
    [
        [0, 2 * WP_SPACING, 0],
        direction _vehicle,
        2
    ] call BIS_fnc_rotateVector3D
);
_vehicleGroup addWaypoint [_wpPosAGL2, 0, _wpIndex2, "Jib Ingress"];
[_vehicleGroup, _wpIndex2] setWaypointType "MOVE";
[_vehicleGroup, _wpIndex2] setWaypointStatements [
    "true",
    "[this] call jib_logistics_paradrop_wpIngressComplete"
];

// WP 3: Drop
if (isNil "jib_logistics_paradrop_paraVehicle") then {
    // Para vehicle (all)
    jib_logistics_paradrop_paraVehicle = {
        params ["_vehicle", "_groups"];
        private _brightness = _vehicle getVariable VAR_LIGHT_BRIGHTNESS;
        private _color = [0,1,0];
        {
            _x setLightColor _color;
            _x setLightAmbient _color;
            _x setLightBrightness _brightness # 2;
        } forEach (_vehicle getVariable VAR_LIGHTS);
        if (!isServer) exitWith {};
        uiSleep 1;
        _vehicle setVehicleCargo objNull;
        private _height = _vehicle getVariable VAR_HEIGHT;
        private _interval = _vehicle getVariable VAR_INTERVAL;
        private _invincible = _vehicle getVariable VAR_INVINCIBLE;
        for "_i" from 0 to count _groups - 1 do {
            private _group = _groups # _i;
            for "_j" from 0 to count units _group - 1 do {
                private _unit = units _group # _j;
                [_unit, _height, _invincible] remoteExec [
                    "jib_logistics_paradrop_paraUnit", _unit
                ];
                uiSleep _interval;
            };
            [_vehicle, _group] remoteExec [
                "jib_logistics_paradrop_paraGroupCleanup", _group
            ];
        };
    };
    publicVariable "jib_logistics_paradrop_paraVehicle";
};
if (isNil "jib_logistics_paradrop_paraUnit") then {
    // Para unit (local)
    jib_logistics_paradrop_paraUnit = {
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
    };
    publicVariable "jib_logistics_paradrop_paraUnit";
};
if (isNil "jib_logistics_paradrop_paraGroupCleanup") then {
    // Para group cleanup (local)
    jib_logistics_paradrop_paraGroupCleanup = {
        params ["_vehicle", "_group"];
        if (not local _group) then {throw "Group not local!"};
        [_vehicle, _group] spawn {
            params ["_vehicle", "_group"];
            waitUntil {{_x in _vehicle} count units _group == 0};
            _group leaveVehicle _vehicle;
            [units _group] allowGetIn true;
        };
    };
    publicVariable "jib_logistics_paradrop_paraGroupCleanup";
};
if (isNil "jib_logistics_paradrop_wpDropComplete") then {
    // Drop WP completion (server)
    jib_logistics_paradrop_wpDropComplete = {
        if (!isServer) then {throw "Not server!"};
        params ["_group"];
        private _vehicle = vehicle leader _group;
        private _groups = [];
        {
            if (_x in units group effectiveCommander _vehicle) then {continue};
            _groups pushBackUnique group _x;
        } forEach crew _vehicle;
        private _groupsSorted = [_groups, [], {groupId _x}] call BIS_fnc_sortBy;
        [_vehicle, _groupsSorted] remoteExec [
            "jib_logistics_paradrop_paraVehicle", 0
        ];
    };
};
private _wpIndex3 = _vehicleCurrentWP + 2;
private _wpPosAGL3 = _vehiclePosATL vectorAdd (
    [
        [0, 3 * WP_SPACING, 0],
        direction _vehicle,
        2
    ] call BIS_fnc_rotateVector3D
);
_vehicleGroup addWaypoint [_wpPosAGL3, 0, _wpIndex3, "Jib Drop"];
[_vehicleGroup, _wpIndex3] setWaypointType "MOVE";
[_vehicleGroup, _wpIndex3] setWaypointBehaviour "CARELESS";
[_vehicleGroup, _wpIndex3] setWaypointStatements [
    "true",
    "[this] call jib_logistics_paradrop_wpDropComplete"
];

// WP 4: Egress
if (isNil "jib_logistics_paradrop_vehicleCleanup") then {
    // Vehicle cleanup (all)
    jib_logistics_paradrop_vehicleCleanup = {
        params ["_vehicle"];
        private _doors = _vehicle getVariable VAR_DOORS;
        _vehicle animateDoor _doors # 1;
        uiSleep 2;
        { deleteVehicle _x } forEach (_vehicle getVariable VAR_LIGHTS);
        _vehicle setVariable [VAR_LIGHTS, nil];
    };
    publicVariable "jib_logistics_paradrop_vehicleCleanup";
};
if (isNil "jib_logistics_paradrop_wpEgressComplete") then {
    // Egress WP completion (server)
    jib_logistics_paradrop_wpEgressComplete = {
        if (!isServer) then {throw "Not server!"};
        params ["_group"];
        private _vehicle = vehicle leader _group;
        [_vehicle] remoteExec ["jib_logistics_paradrop_vehicleCleanup", 0];
    };
};
private _wpIndex4 = _vehicleCurrentWP + 3;
private _wpPosAGL4 = _vehiclePosATL vectorAdd (
    [
        [0, 4 * WP_SPACING, 0],
        direction _vehicle,
        2
    ] call BIS_fnc_rotateVector3D
);
_vehicleGroup addWaypoint [_wpPosAGL4, 0, _wpIndex4, "Jib Egress"];
[_vehicleGroup, _wpIndex4] setWaypointType "MOVE";
[_vehicleGroup, _wpIndex4] setWaypointStatements [
    "true",
    "[this] call jib_logistics_paradrop_wpEgressComplete"
];

// WP 5: RTB
if (isNil "jib_logistics_paradrop_wpRTBComplete") then {
    // RTB WP completion (server)
    jib_logistics_paradrop_wpRTBComplete = {
        params ["_group"];
        if (!isServer) then {throw "Not server!"};
        private _vehicle = vehicle leader _group;
        deleteVehicleCrew _vehicle;
        deleteVehicle _vehicle;
    };
};
private _wpIndex5 = _vehicleCurrentWP + 4;
private _wpPosAGL5 = _vehiclePosATL vectorAdd (
    [
        [0, 5 * WP_SPACING, 0],
        direction _vehicle,
        2
    ] call BIS_fnc_rotateVector3D
);
_vehicleGroup addWaypoint [_wpPosAGL5, 0, _wpIndex5, "Jib RTB"];
[_vehicleGroup, _wpIndex5] setWaypointType "MOVE";
[_vehicleGroup, _wpIndex5] setWaypointStatements [
    "true",
    "[this] call jib_logistics_paradrop_wpRTBComplete"
];
