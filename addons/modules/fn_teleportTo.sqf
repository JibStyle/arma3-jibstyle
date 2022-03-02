// Teleport previously selected player
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced entity
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Pop recorded entity
if (isNil "jib_modules_teleportFrom") then {
    jib_modules_teleportFrom = objNull;
};
private _unit = jib_modules_teleportFrom;
jib_modules_teleportFrom = objNull;

// Call function
try {
    [[_unit], getPosATL _logic] call jib_teleport_fnc_teleport;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
