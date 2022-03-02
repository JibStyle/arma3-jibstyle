// Add waypoint to wait until logistics start
#define WP_SPACING 10
#define VAR_START "jib_logistics_start"
params ["_unit"];
if (!isServer) then {throw "Not server!"};
if (!alive _unit) then {throw "Vehicle not alive!"};

// Vehicle setup
private _vehicle = vehicle _unit;
private _vehiclePosATL = getPosATL _vehicle;
private _vehicleGroup = group effectiveCommander _vehicle;
private _vehicleAppendWP = count waypoints _vehicleGroup;
_vehicle setVariable [VAR_START, false, true];

// WP 1: Wait
if (isNil "jib_logistics_wait_wpWaitCondition") then {
    // Wait WP condition (local)
    jib_logistics_wait_wpWaitCondition = {
        params ["_group"];
        private _vehicle = vehicle leader _group;
        _vehicle getVariable [VAR_START, false];
    };
    publicVariable "jib_logistics_wait_wpWaitCondition";
};
if (isNil "jib_logistics_wait_wpWaitComplete") then {
    // Wait WP completion (server)
    jib_logistics_wait_wpWaitComplete = {
        params ["_group"];
        private _vehicle = vehicle leader _group;
    };
};
private _wpIndex1 = _vehicleAppendWP;
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
    "[this] call jib_logistics_wait_wpWaitCondition",
    "[this] call jib_logistics_wait_wpWaitComplete"
];
