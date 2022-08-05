// Add guard waypoint to selected unit
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced entity
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Call function
try {
    [group _entity] call jib_wp_fnc_guard;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
