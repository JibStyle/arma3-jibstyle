// Designate player to select from
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced object
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Record selection
jib_modules_selectPlayerFrom = _entity;

// Delete logic
deleteVehicle _logic;
