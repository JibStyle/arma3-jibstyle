// Replace dummy with selected vehicle type, uncrewed.
params ["_logic", "_units", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced entity
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Ensure recorded entity initialized
if (isNil "jib_modules_misc_replaceFrom") then {
    jib_modules_misc_replaceFrom = objNull;
};
private _newType = jib_modules_misc_replaceFrom;

// Call function
try {
    [_entity, _newType, false] call jib_misc_fnc_replaceDummy;
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
