// Add waypoint to delete vehicle
#define WP_SPACING 500
params ["_unit"];
if (!isServer) then {throw "Not server!"};
if (!alive _unit) then {throw "Vehicle not alive!"};

// Vehicle setup
private _vehicle = vehicle _unit;
private _vehiclePosATL = getPosATL _vehicle;
private _vehicleGroup = group effectiveCommander _vehicle;
private _vehicleAppendWP = count waypoints _vehicleGroup;

// WP 1: RTB
if (isNil "jib_logistics_rtb_wpRTBComplete") then {
    // RTB WP completion (server)
    jib_logistics_rtb_wpRTBComplete = {
        params ["_group"];
        if (!isServer) then {throw "Not server!"};
        private _vehicle = vehicle leader _group;
        deleteVehicleCrew _vehicle;
        deleteVehicle _vehicle;
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
_vehicleGroup addWaypoint [_wpPosAGL1, 0, _wpIndex1, "Jib RTB"];
[_vehicleGroup, _wpIndex1] setWaypointType "MOVE";
[_vehicleGroup, _wpIndex1] setWaypointStatements [
    "true",
    "[this] call jib_logistics_rtb_wpRTBComplete"
];
