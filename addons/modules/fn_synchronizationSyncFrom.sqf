// Record entity to sync from
params ["_logic", "", "_isActivated"];
if (!_isActivated) exitWith {};
if (!isServer) then {throw "Not server!"};

private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object", objNull
];

jib_modules_synchronizationSyncFrom = _entity;
deleteVehicle _logic;
