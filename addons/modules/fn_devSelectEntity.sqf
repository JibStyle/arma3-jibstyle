// Designate player to select from
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not local _logic) exitWith { false };

// Get synced object
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Record selection
jib_modules_devSelectEntity = _entity;
private _message = format [
    "jib_modules_devSelectEntity: %1 - Type (copied): %2 - ASL: %3 - AGL: %4",
    _entity,
    typeOf _entity,
    getPosASL _entity,
    getPosATL _entity
];
[objNull, _message] call BIS_fnc_showCuratorFeedbackMessage;
deleteVehicle _logic;
