// Enable AI lasers when SL laser active
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced entity
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];
private _group = group _entity;

// Call function
try {
    [_group] call jib_ai_fnc_enableLaserControl;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};

// Disable when module deleted
[_logic, _group] spawn {
    params ["_logic", "_group"];
    waitUntil { isNull _logic };
    [_group] call jib_ai_fnc_disableLaserControl;
};
