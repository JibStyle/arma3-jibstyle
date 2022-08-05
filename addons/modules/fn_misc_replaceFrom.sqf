// Designate new type to use for replacement.
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced object
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Record selection
jib_modules_misc_replaceFrom = typeOf _entity;

// Delete logic
deleteVehicle _logic;
