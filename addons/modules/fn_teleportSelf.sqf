// Teleport player
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not hasInterface) exitWith { "Not client!"; };
if (not local _logic) exitWith { false };

// Call function
[[vehicle player, getPosATL _logic], {
    params ["_unit", "_posATL"];
    try {
        [[_unit], _posATL] call jib_teleport_fnc_teleport;
    } catch {
        [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
    };
}] remoteExec ["spawn", 2];
deleteVehicle _logic;
