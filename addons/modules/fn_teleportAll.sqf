// Teleport all players
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Gather units
private _vehicles = [];
{
    _vehicles pushBackUnique vehicle _x;
} forEach allPlayers;

// Call function
try {
    [_vehicles, getPosATL _logic] call jib_teleport_fnc_teleport;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
