if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_wp_moduleValidate = {};

// Dependency to trigger transport for paradrop ingress.
jib_wp_paraEffectIngress = {params ["_group"];};

// Dependency to trigger transport for paradrop unload.
jib_wp_paraEffectDropzone = {params ["_group"];};

// Dependency to trigger transport for paradrop egress.
jib_wp_paraEffectEgress = {params ["_group"];};

// Dependency to trigger transport for paradrop unload.
jib_wp_paraUnload = {params ["_group", "_height"];};

// Print debug description of group waypoints
jib_wp_debug = {
    params ["_group"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _group) then {throw "No group selected!"};
    private _data = waypoints _group apply {
        _x params ["_group", "_index"];
        [
            _index,
            waypointName [_group, _index],
            mapGridPosition waypointPosition [_group, _index],
            // waypointPosition [_group, _index],
            waypointType [_group, _index],
            // waypointBehaviour [_group, _index],
            waypointStatements [_group, _index]
        ];
    };
    systemChat format [
        "Group: %1, Current WP: %2, All WPs...",
        _group,
        currentWaypoint _group
    ];
    _data apply {
        systemChat str _x;
    };
};

// Add guard waypoint to group
jib_wp_guard = {
    params ["_group"];
    if (not isServer) then {throw "Not server!"};
    if (isNull _group) then {throw "No group selected!"};
    [
        _group,
        0,
        "GUARD",
        "UNCHANGED",
        "true",
        "",
        "jib_wp_guard"
    ] call jib_wp_add;
};

// Add waypoint to wait until start signal
jib_wp_wait = {
    params ["_group"];
    if (!isServer) then {throw "Not server!"};
    if (isNull _group) then {throw "No group selected!"};
    _group setVariable [jib_wp_varStart, false, true];
    [
        _group,
        10,
        "SCRIPTED",
        "UNCHANGED",
        "[this] call jib_wp_waitCondition",
        "",
        "jib_wp_wait"
    ] call jib_wp_add;
};

// Make wait WP complete
jib_wp_start = {
    params ["_group"];
    if (!isServer) then {throw "Not server!"};
    if (isNull _group) then {throw "No group selected!"};
    _group setVariable [jib_wp_varStart, true, true];
};

// Add paradrop waypoints.
//
// Creates two waypoints: an ingress waypoint and an egress
// waypoint. Scripts are added for controlling lights, door, and
// unloading cargo. Drop occurs at halfway between the two waypoints.
jib_wp_paradrop = {
    params ["_group", ["_height", 1e11]];
    if (!isServer) then {throw "Not server!"};
    if (isNull _group) then {throw "No group selected!"};
    _group setVariable [jib_wp_varParadropHeight, _height];
    [
        _group,
        100,
        "MOVE",
        "UNCHANGED",
        "true",
        "[this] call jib_wp_paradropIngressComplete",
        "jib_wp_paradropIngress"
    ] call jib_wp_add;
    [
        _group,
        200,
        "MOVE",
        "UNCHANGED",
        "true",
        "[this] call jib_wp_paradropEgressComplete",
        "jib_wp_paradropEgress"
    ] call jib_wp_add;
};

// Add waypoint to delete group vehicles
jib_wp_rtb = {
    params ["_group"];
    if (!isServer) then {throw "Not server!"};
    if (isNull _group) then {throw "No group selected!"};
    [
        _group,
        500,
        "MOVE",
        "UNCHANGED",
        "true",
        "[this] call jib_wp_rtbComplete",
        "jib_wp_rtb"
    ] call jib_wp_add;
};

// PRIVATE BELOW HERE

// Common code to add a waypoint
jib_wp_add = {
    params [
        "_group",
        "_spacing",
        "_type",
        "_behaviour",
        "_condition",
        "_completion",
        "_name"
    ];
    if (!isServer) then {throw "Not server!"};
    private _vehicle = vehicle leader _group;
    private _index = count waypoints _group;
    _group addWaypoint [
        getPosATL _vehicle vectorAdd (
            [
                [0, _spacing, 0],
                direction _vehicle,
                2
            ] call BIS_fnc_rotateVector3D
        ),
        0,
        _index,
        _name
    ];
    [_group, _index] setWaypointBehaviour _behaviour;
    [_group, _index] setWaypointType _type;
    [_group, _index] setWaypointStatements [_condition, _completion];
};

// Detect when halfway to current waypoint
jib_wp_interpolate = {
    params ["_waypoint", "_interpolation", "_complete"];
    _waypoint params ["_group", "_index"];
    if (!isServer) then {throw "Not server!"};
    if (!canSuspend) then {throw "Cannot suspend!"};
    private _vehicle = vehicle leader _group;
    private _waypointPosition = waypointPosition _waypoint;
    private _totalDistance = _vehicle distance2D _waypointPosition;
    waitUntil {
        _vehicle distance2D _waypointPosition
            < _totalDistance * (1.0 - _interpolation)
    };
    [leader _group] remoteExec [_complete, 0];
};

// Group variable for wait waypoint condition
jib_wp_varStart = "jib_wp_varStart";

// Group variable for paradrop parachute open height
jib_wp_varParadropHeight = "jib_wp_varParadropHeight";

// Wait WP condition (local)
jib_wp_waitCondition = {
    params ["_leader"];
    group _leader getVariable [jib_wp_varStart, false];
};

// Paradrop ingress WP completion (all)
jib_wp_paradropIngressComplete = {
    params ["_leader"];
    private _group = group _leader;
    [_group] spawn jib_wp_paraEffectIngress;

    // Detect halfway to next WP (server)
    if (!isServer) exitWith {};
    [
        [_group, currentWaypoint _group + 1],
        0.5,
        "jib_wp_paradropDropzoneComplete"
    ] spawn jib_wp_interpolate;
};

// Paradrop dropzone pseudo-WP completion (all)
jib_wp_paradropDropzoneComplete = {
    params ["_leader"];
    private _group = group _leader;
    [_group] call jib_wp_paraEffectDropzone;

    // Unload (server)
    if (!isServer) exitWith {};
    uiSleep 1;
    [
        _group,
        _group getVariable [jib_wp_varParadropHeight, 1e11]
    ] call jib_wp_paraUnload;
};

// Paradrop egress WP completion (all)
jib_wp_paradropEgressComplete = {
    params ["_leader"];
    private _group = group _leader;
    [_group] spawn jib_wp_paraEffectEgress;
};

// RTB WP completion (server)
jib_wp_rtbComplete = {
    params ["_leader"];
    if (!isServer) exitWith {};
    private _vehicles = [];
    units group _leader apply {
        _vehicles pushBackUnique vehicle _x;
    };
    _vehicles apply {
        deleteVehicleCrew _x;
        deleteVehicle _x;
    };
};

jib_wp_moduleDebug = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached] call jib_wp_debug;
        },
        [],
        "local"
    ] call jib_wp_moduleValidate;
};

jib_wp_moduleGuard = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached] call jib_wp_guard;
        }
    ] call jib_wp_moduleValidate;
};

jib_wp_moduleWait = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached] call jib_wp_wait;
        }
    ] call jib_wp_moduleValidate;
};

jib_wp_moduleStart = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached] call jib_wp_start;
        }
    ] call jib_wp_moduleValidate;
};

jib_wp_moduleParadrop = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached] call jib_wp_paradrop;
        }
    ] call jib_wp_moduleValidate;
};

jib_wp_moduleParadropHALO = { // Recommend 1500 fly height
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached, 200] call jib_wp_paradrop;
        }
    ] call jib_wp_moduleValidate;
};

jib_wp_moduleRTB = {
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached] call jib_wp_rtb;
        }
    ] call jib_wp_moduleValidate;
};

publicVariable "jib_wp_moduleValidate";
publicVariable "jib_wp_paraEffectIngress";
publicVariable "jib_wp_paraEffectDropzone";
publicVariable "jib_wp_paraEffectEgress";
publicVariable "jib_wp_paraUnload";
publicVariable "jib_wp_moduleDebug";
publicVariable "jib_wp_moduleGuard";
publicVariable "jib_wp_moduleWait";
publicVariable "jib_wp_moduleStart";
publicVariable "jib_wp_moduleParadrop";
publicVariable "jib_wp_moduleParadropHALO";
publicVariable "jib_wp_moduleRTB";
publicVariable "jib_wp_varStart";
publicVariable "jib_wp_waitCondition";
publicVariable "jib_wp_paradropIngressComplete";
publicVariable "jib_wp_paradropDropzoneComplete";
publicVariable "jib_wp_paradropEgressComplete";
publicVariable "jib_wp_rtbComplete";
