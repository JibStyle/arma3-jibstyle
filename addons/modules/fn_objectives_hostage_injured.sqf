// Make unit an injured hostage.
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
    [_entity, true] call jib_objectives_fnc_hostage;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
