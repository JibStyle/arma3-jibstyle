// Select player and transfer curator ownership
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced entity
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Pop recorded entity
if (isNil "jib_modules_selectPlayerFrom") then {
    jib_modules_selectPlayerFrom = objNull;
};
private _oldUnit = jib_modules_selectPlayerFrom;
jib_modules_selectPlayerFrom = objNull;

// Call function
try {
    [_oldUnit, _entity] call jib_selectPlayer_fnc_selectPlayer;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
