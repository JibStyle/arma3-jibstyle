if (!isServer) exitWith {};

// Validate module logic then run inner code.
//
// Dependency injected from integration.
jib_wp_moduleValidate = {};

// Dependency to trigger transport for paradrop ingress.
jib_wp_paraIngress = {params ["_group"];};

// Dependency to trigger transport for paradrop unload.
jib_wp_paraUnload = {params ["_group", "_height"];};

// Dependency to trigger transport for paradrop egress.
jib_wp_paraEgress = {params ["_group"];};

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
        ""
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
        ""
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
        "[this] call jib_wp_paradropIngressCompletion"
    ] call jib_wp_add;
    [
        _group,
        100,
        "MOVE",
        "UNCHANGED",
        "true",
        "[this] call jib_wp_paradropEgressCompletion"
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
        "[this] call jib_wp_rtbCompletion"
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
        "_completion"
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
        _index
    ];
    [_group, _index] setWaypointBehaviour _behaviour;
    [_group, _index] setWaypointType _type;
    [_group, _index] setWaypointStatements [_condition, _completion];
};

// Group variable for wait waypoint condition
jib_wp_varStart = "jib_wp_varStart";

// Group variable for paradrop parachute open height
jib_wp_varParadropHeight = "jib_wp_varParadropHeight";

// Wait WP condition (local)
jib_wp_waitCondition = {
    params ["_group"];
    _group getVariable [jib_wp_varStart, false];
};

// Paradrop ingress WP completion (all)
jib_wp_paradropIngressCompletion = {
    params ["_group"];
    [_group] spawn jib_wp_paraIngress;
    if (!isServer) exitWith {};

    // Detect drop zone
    [_group] spawn {
        params ["_group"];
        private _interpolation = 0.5; // DZ placement between WPs
        private _height =
            _group getVariable [jib_wp_varParadropHeight, 1e11];
        private _vehicle = vehicle leader _group;
        private _egressPos = waypointPosition [
            _group,
            currentWaypoint _group
        ];
        private _wpDistance = _vehicle distance2D _egressPos;
        waitUntil {
            _vehicle distance2D _egressPos
                < _wpDistance * (1.0 - _interpolation)
        };
        [_group, _height] call jib_wp_paraUnload;
    };
};

// Paradrop egress WP completion (all)
jib_wp_paradropEgressCompletion = {
    params ["_group"];
    [_group] spawn jib_wp_paraEgress;
};

// RTB WP completion (server)
jib_wp_rtbCompletion = {
    params ["_group"];
    if (!isServer) exitWith {};
    private _vehicles = [];
    units _group apply {
        _vehicles pushBackUnique vehicle _x;
    };
    _vehicles apply {
        deleteVehicleCrew _x;
        deleteVehicle _x;
    };
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
            [group _attached] call jib_wp_rtb;
        }
    ] call jib_wp_moduleValidate;
};

jib_wp_moduleParadropHALO = { // Recommend 1500 fly height
    [
        _this,
        {
            params ["_posATL", "_attached", "_args"];
            [group _attached, 200] call jib_wp_rtb;
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
publicVariable "jib_wp_paraIngress";
publicVariable "jib_wp_paraUnload";
publicVariable "jib_wp_paraEgress";
publicVariable "jib_wp_moduleGuard";
publicVariable "jib_wp_moduleWait";
publicVariable "jib_wp_moduleStart";
publicVariable "jib_wp_moduleParadrop";
publicVariable "jib_wp_moduleParadropHALO";
publicVariable "jib_wp_moduleRTB";
publicVariable "jib_wp_varStart";
publicVariable "jib_wp_waitCondition";
publicVariable "jib_wp_paradropIngressCompletion";
publicVariable "jib_wp_paradropEgressCompletion";
publicVariable "jib_wp_rtbCompletion";
