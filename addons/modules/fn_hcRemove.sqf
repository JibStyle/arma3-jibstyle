// Remove unit's group from HC.
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not isServer) then {throw systemChat "Not server!"};

// Get entity
private _subordinate = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];
private _group = group _subordinate;

// Remove group from HC
try {
    [_group] call jib_hc_fnc_remove;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
