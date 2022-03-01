// Designate player to select from
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not local _logic) exitWith { false };

// Record selection
private _pos = getPosATL _logic;
jib_modules_devCopyPositionATL = _pos;
copyToClipboard str _pos;
[
    objNull,
    [format "jib_modules_devCopyPositionATL: %1", _pos]
] call BIS_fnc_showCuratorFeedbackMessage;
deleteVehicle _logic;
