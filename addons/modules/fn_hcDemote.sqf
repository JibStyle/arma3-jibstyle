// Remove all subordinate groups from commander.
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced entity
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Call function
try {
    [_entity] call jib_hc_fnc_demote;
    [] remoteExec ["jib_hc_fnc_debug", _logic];
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
