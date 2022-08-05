// Make unit a commander.
//
// If unit already a commander, they are unaffected. Also, unit saved
// in global variable and used later by HC Add module.
params ["_logic", "", "_isActivated"];
if (not _isActivated) exitWith { "Not activated!"; };
if (not isServer) then {throw "Not server!"};

// Get synced entity
private _entity = _logic getvariable [
    "bis_fnc_curatorAttachObject_object",
    objNull
];

// Save for HC Add module
jib_modules_hcSelected = _entity;

// Call function
try {
    [_entity] call jib_hc_fnc_promote;
    [] remoteExec ["jib_hc_fnc_debug", _logic];
} catch {
    [objNull, str _exception] call BIS_fnc_showCuratorFeedbackMessage;
};
deleteVehicle _logic;
