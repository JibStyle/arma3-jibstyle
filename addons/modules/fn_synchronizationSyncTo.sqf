// Sync designated entities
params ["_logic", "", "_isActivated"];
if (!_isActivated) exitWith {};
if (!isServer) then {throw "Not server!"};
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object", objNull
];
if (
    isNil "jib_modules_synchronizationSyncFrom"
        || {isNull jib_modules_synchronizationSyncFrom}
        || {isNull _entity}
) then {
    [objNull, "Null entity!"] call BIS_fnc_showCuratorFeedbackMessage;
} else {
    jib_modules_synchronizationSyncFrom synchronizeObjectsAdd [_entity];
};
deleteVehicle _logic;
