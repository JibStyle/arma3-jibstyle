// Select player and transfer curator ownership.
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not hasInterface) exitWith { "Not client!"; };
if (not local _logic) exitWith { false };

// Get synced entity
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Call function
[[player, _entity], {
    params ["_oldUnit", "_newUnit"];
    try {
        [_oldUnit, _newUnit] call jib_selectPlayer_fnc_selectPlayer;
    } catch {
        [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
    };
}] remoteExec ["spawn", 2];
deleteVehicle _logic;
