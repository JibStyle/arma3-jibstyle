// Designate player to select from
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { systemChat "Not activated!"; };
if (not isServer) exitWith { systemChat "Not server!"; };

// Get selected unit
private _unit = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Record selection
jib_selectPlayer_from = _unit

deleteVehicle _logic;
true;
